import Foundation
import XCTest
import HTTPTypes
import OpenAPIRuntime
import HydraKitNetwork
@testable import HydraKitOpenAPI

final class HKOpenAPIClientTransportTests: XCTestCase {
    func testConvertsRequestAndResponsePreservingEncodedPathAndQuery() async throws {
        let network = HKMockNetworkClient()
        network.enqueue(StubResponse(data: Data("reply".utf8), status: .init(rawValue: 201), headers: ["X-Reply": "yes"]))
        let transport = HKOpenAPIClientTransport(networkClient: network)
        let request = HTTPRequest(method: .post, scheme: nil, authority: nil, path: "/items/a%2Fb?q=a%20b&tag=1&tag=2", headerFields: [.contentType: "text/plain"])
        let (response, body) = try await transport.send(request, body: HTTPBody(Data("hello".utf8)), baseURL: URL(string: "https://example.com/api/v1/")!, operationID: "create")
        let sent = try XCTUnwrap(network.requests.first)
        XCTAssertEqual(sent.url?.absoluteString, "https://example.com/api/v1/items/a%2Fb?q=a%20b&tag=1&tag=2")
        XCTAssertEqual(sent.httpMethod, "POST")
        XCTAssertEqual(sent.value(forHTTPHeaderField: "Content-Type"), "text/plain")
        XCTAssertEqual(sent.httpBody, Data("hello".utf8))
        XCTAssertEqual(response.status.code, 201)
        XCTAssertEqual(response.headerFields[HTTPField.Name("X-Reply")!], "yes")
        let data = try await Data(collecting: XCTUnwrap(body), upTo: 1024)
        XCTAssertEqual(data, Data("reply".utf8))
    }

    func testPreservesLeadingDoubleSlashAsOperationPath() async throws {
        let network = HKMockNetworkClient()
        network.enqueue(StubResponse())
        _ = try await HKOpenAPIClientTransport(networkClient: network).send(
            HTTPRequest(method: .get, scheme: nil, authority: nil, path: "//ping/foo?q=a%2Fb"),
            body: nil, baseURL: URL(string: "https://example.com/api")!, operationID: "get")
        XCTAssertEqual(network.requests.first?.url?.absoluteString, "https://example.com/api//ping/foo?q=a%2Fb")
    }

    func testNilRequestBodyAndEmptyResponse() async throws {
        let network = HKMockNetworkClient()
        network.enqueue(StubResponse(status: .init(rawValue: 204)))
        let (response, body) = try await HKOpenAPIClientTransport(networkClient: network).send(
            HTTPRequest(method: .delete, scheme: nil, authority: nil, path: "/item"), body: nil,
            baseURL: URL(string: "https://example.com/api")!, operationID: "delete")
        XCTAssertNil(network.requests.first?.httpBody)
        XCTAssertEqual(network.requests.first?.url?.absoluteString, "https://example.com/api/item")
        XCTAssertEqual(response.status.code, 204)
        let data = try await Data(collecting: XCTUnwrap(body), upTo: 1024)
        XCTAssertTrue(data.isEmpty)
    }

    func testConvertsNonSuccessStatusesIntoResponses() async throws {
        for status in [404, 422, 500] {
            let network = HKMockNetworkClient()
            network.enqueue(StubResponse(data: Data("error-body".utf8), status: .init(rawValue: status)))
            let (response, body) = try await HKOpenAPIClientTransport(networkClient: network).send(
                HTTPRequest(method: .get, scheme: nil, authority: nil, path: "/ping"), body: nil,
                baseURL: URL(string: "https://example.com")!, operationID: "getPing")
            XCTAssertEqual(response.status.code, status)
            let data = try await Data(collecting: XCTUnwrap(body), upTo: 1024)
            XCTAssertEqual(data, Data("error-body".utf8))
        }
    }

    func testPreservesTransportError() async throws {
        let network = HKMockNetworkClient()
        network.enqueue(HKNetworkError.transportFailed(URLError(.timedOut)))
        do {
            _ = try await HKOpenAPIClientTransport(networkClient: network).send(
                HTTPRequest(method: .get, scheme: nil, authority: nil, path: "/ping"), body: nil,
                baseURL: URL(string: "https://example.com")!, operationID: "getPing")
            XCTFail("Expected transport error")
        } catch HKNetworkError.transportFailed(let error) {
            XCTAssertEqual((error as? URLError)?.code, .timedOut)
        }
    }

    func testPreservesCancellation() async throws {
        let network = HKMockNetworkClient()
        network.enqueue(CancellationError())
        do {
            _ = try await HKOpenAPIClientTransport(networkClient: network).send(
                HTTPRequest(method: .get, scheme: nil, authority: nil, path: "/ping"), body: nil,
                baseURL: URL(string: "https://example.com")!, operationID: "getPing")
            XCTFail("Expected cancellation")
        } catch is CancellationError {}
    }

    func testRejectsNegativeBodyLimitWithoutCrashingOrSending() async throws {
        let network = HKMockNetworkClient()
        network.enqueue(StubResponse())
        let transport = HKOpenAPIClientTransport(networkClient: network, maximumRequestBodyBytes: -1)
        do {
            _ = try await transport.send(
                HTTPRequest(method: .get, scheme: nil, authority: nil, path: "/ping"), body: nil,
                baseURL: URL(string: "https://example.com")!, operationID: "getPing")
            XCTFail("Expected configuration error even when request has no body")
        } catch let error as HKOpenAPITransportError {
            XCTAssertEqual(error, .invalidMaximumRequestBodyBytes(-1))
            XCTAssertTrue(network.requests.isEmpty)
        }
    }

    func testZeroLimitAllowsEmptyBody() async throws {
        let network = HKMockNetworkClient()
        network.enqueue(StubResponse())
        _ = try await HKOpenAPIClientTransport(networkClient: network, maximumRequestBodyBytes: 0).send(
            HTTPRequest(method: .post, scheme: nil, authority: nil, path: "/ping"), body: HTTPBody(Data()),
            baseURL: URL(string: "https://example.com")!, operationID: "getPing")
        XCTAssertEqual(network.requests.first?.httpBody, Data())
    }

    func testRejectsBodyOverConfiguredLimitBeforeSending() async throws {
        let network = HKMockNetworkClient()
        do {
            _ = try await HKOpenAPIClientTransport(networkClient: network, maximumRequestBodyBytes: 2).send(
                HTTPRequest(method: .post, scheme: nil, authority: nil, path: "/upload"), body: HTTPBody(Data("large".utf8)),
                baseURL: URL(string: "https://example.com")!, operationID: "upload")
            XCTFail("Expected body limit error")
        } catch {
            XCTAssertTrue(network.requests.isEmpty)
        }
    }
}
