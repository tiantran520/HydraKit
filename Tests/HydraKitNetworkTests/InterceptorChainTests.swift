import Foundation
import XCTest
@testable import HydraKitNetwork

final class InterceptorChainTests: XCTestCase {
    func testRequestInterceptorsRunInOrder() async throws {
        let chain = HKInterceptorChain(requestInterceptors: [
            TestRequestInterceptor(id: "first", headerName: "X-First", headerValue: "1"),
            TestRequestInterceptor(id: "second", headerName: "X-Second", headerValue: "2")
        ])

        let request = URLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))

        let intercepted = try await chain.intercept(request)

        XCTAssertEqual(intercepted.value(forHTTPHeaderField: "X-First"), "1")
        XCTAssertEqual(intercepted.value(forHTTPHeaderField: "X-Second"), "2")
        XCTAssertEqual(chain.requestInterceptorIDs, ["first", "second"])
    }

    func testCanAddAndRemoveRequestInterceptorAtRuntime() async throws {
        let chain = HKInterceptorChain()
        chain.addRequestInterceptor(TestRequestInterceptor(id: "one", headerName: "X-One", headerValue: "1"))
        chain.addRequestInterceptor(TestRequestInterceptor(id: "two", headerName: "X-Two", headerValue: "2"))
        chain.removeRequestInterceptor(id: "one")

        let request = URLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))

        let intercepted = try await chain.intercept(request)

        XCTAssertNil(intercepted.value(forHTTPHeaderField: "X-One"))
        XCTAssertEqual(intercepted.value(forHTTPHeaderField: "X-Two"), "2")
        XCTAssertEqual(chain.requestInterceptorIDs, ["two"])
    }

    func testResponseInterceptorsRunInOrder() async throws {
        let chain = HKInterceptorChain(responseInterceptors: [
            TestResponseInterceptor(id: "first", headerName: "X-First", headerValue: "1"),
            TestResponseInterceptor(id: "second", headerName: "X-Second", headerValue: "2")
        ])

        let response = Response(
            value: Data(),
            status: .ok,
            headers: HTTPHeaders(),
            url: URL(string: "https://example.com")
        )

        let intercepted = try await chain.intercept(response)

        XCTAssertEqual(intercepted.headers["X-First"], "1")
        XCTAssertEqual(intercepted.headers["X-Second"], "2")
        XCTAssertEqual(chain.responseInterceptorIDs, ["first", "second"])
    }

    func testHeaderAndAuthInterceptorsMutateRequest() async throws {
        let chain = HKInterceptorChain(requestInterceptors: [
            HeaderInterceptor(headers: ["X-App": "IronBit"]),
            AuthInterceptor { "token" }
        ])

        let request = URLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))

        let intercepted = try await chain.intercept(request)

        XCTAssertEqual(intercepted.value(forHTTPHeaderField: "X-App"), "IronBit")
        XCTAssertEqual(intercepted.value(forHTTPHeaderField: "Authorization"), "Bearer token")
    }
}

private struct TestRequestInterceptor: RequestInterceptor {
    let id: String
    let headerName: String
    let headerValue: String

    func intercept(_ request: URLRequest) async throws -> URLRequest {
        var request = request
        request.setValue(headerValue, forHTTPHeaderField: headerName)
        return request
    }
}

private struct TestResponseInterceptor: ResponseInterceptor {
    let id: String
    let headerName: String
    let headerValue: String

    func intercept(_ response: Response<Data>) async throws -> Response<Data> {
        var headers = response.headers
        headers[headerName] = headerValue

        return Response(
            value: response.value,
            status: response.status,
            headers: headers,
            url: response.url
        )
    }
}
