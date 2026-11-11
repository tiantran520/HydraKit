import Foundation
import XCTest
import HydraKit
import HydraKitNetwork
import OpenAPIRuntime
import HydraKitOpenAPI

final class HydraKitOpenAPISmokeTests: XCTestCase {
    func testFactoryAndGeneratedOperationThroughDI() async throws {
        let network = HKMockNetworkClient()
        network.enqueue(try .json(["status": "ok"]))
        let container = HKDIContainer()
        container.register((any APIProtocol).self) { _ in
            HydraKitOpenAPI.makeClient(serverURL: URL(string: "https://example.com/api")!, networkClient: network, tokenProvider: { "token" })
        }
        let client = container.resolve((any APIProtocol).self)
        let output = try await client.getPing(.init())
        let payload = try output.ok.body.json
        XCTAssertEqual(payload.status, "ok")
        XCTAssertEqual(network.requests.first?.url?.absoluteString, "https://example.com/api/ping")
        XCTAssertEqual(network.requests.first?.value(forHTTPHeaderField: "Authorization"), "Bearer token")
    }

    func testFactoryWithoutAuth() async throws {
        let network = HKMockNetworkClient()
        network.enqueue(try .json(["status": "ready"]))
        let client = HydraKitOpenAPI.makeClient(serverURL: URL(string: "https://example.com")!, networkClient: network)
        let output = try await client.getPing()
        XCTAssertEqual(try output.ok.body.json.status, "ready")
        XCTAssertNil(network.requests.first?.value(forHTTPHeaderField: "Authorization"))
    }

    func testGeneratedClientDecodesDeclaredNotFoundResponse() async throws {
        let network = HKMockNetworkClient()
        network.enqueue(try .json(["message": "not found"], status: .init(rawValue: 404)))
        let client = HydraKitOpenAPI.makeClient(serverURL: URL(string: "https://example.com")!, networkClient: network)
        let output = try await client.getPing()
        XCTAssertEqual(try output.notFound.body.json.message, "not found")
    }

    func testGeneratedClientWrapsOriginalNetworkError() async throws {
        let network = HKMockNetworkClient()
        network.enqueue(HKNetworkError.invalidResponse)
        let client = HydraKitOpenAPI.makeClient(serverURL: URL(string: "https://example.com")!, networkClient: network)
        do {
            _ = try await client.getPing()
            XCTFail("Expected client error")
        } catch let error as ClientError {
            guard case HKNetworkError.invalidResponse = error.underlyingError else {
                return XCTFail("Lost original network error")
            }
        }
    }
}
