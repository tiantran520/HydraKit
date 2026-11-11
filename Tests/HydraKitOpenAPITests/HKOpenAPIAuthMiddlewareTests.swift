import Foundation
import XCTest
import HTTPTypes
import OpenAPIRuntime
@testable import HydraKitOpenAPI

final class HKOpenAPIAuthMiddlewareTests: XCTestCase {
    func testAttachesTokenAndForwardsContext() async throws {
        let middleware = HKOpenAPIAuthMiddleware(scheme: "Token") { "secret" }
        let url = URL(string: "https://example.com/api")!
        let (_, body) = try await middleware.intercept(HTTPRequest(method: .post, scheme: nil, authority: nil, path: "/item"), body: HTTPBody("payload"), baseURL: url, operationID: "create") { request, body, baseURL in
            XCTAssertEqual(request.headerFields[.authorization], "Token secret")
            XCTAssertEqual(request.path, "/item")
            XCTAssertEqual(request.method, .post)
            XCTAssertEqual(baseURL, url)
            return (HTTPResponse(status: .created), body)
        }
        let data = try await Data(collecting: XCTUnwrap(body), upTo: 1024)
        XCTAssertEqual(String(decoding: data, as: UTF8.self), "payload")
    }

    func testNilAndEmptyTokenPreserveExistingAuthorization() async throws {
        for token in [nil, ""] as [String?] {
            let middleware = HKOpenAPIAuthMiddleware { token }
            _ = try await middleware.intercept(HTTPRequest(method: .get, scheme: nil, authority: nil, path: "/", headerFields: [.authorization: "Existing"]), body: nil, baseURL: URL(string: "https://example.com")!, operationID: "get") { request, body, _ in
                XCTAssertEqual(request.headerFields[.authorization], "Existing")
                XCTAssertNil(body)
                return (HTTPResponse(status: .ok), nil)
            }
        }
    }

    func testProviderFailureDoesNotCallNext() async throws {
        struct TokenError: Error {}
        let middleware = HKOpenAPIAuthMiddleware { throw TokenError() }
        do {
            _ = try await middleware.intercept(HTTPRequest(method: .get, scheme: nil, authority: nil, path: "/"), body: nil, baseURL: URL(string: "https://example.com")!, operationID: "get") { _, _, _ in
                XCTFail("Must not send without successful provider")
                return (HTTPResponse(status: .ok), nil)
            }
            XCTFail("Expected provider error")
        } catch is TokenError {}
    }
}
