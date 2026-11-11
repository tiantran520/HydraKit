import Foundation
import HTTPTypes
import OpenAPIRuntime

/// Adds authorization using the same token-provider pattern as `AuthInterceptor`.
public struct HKOpenAPIAuthMiddleware: ClientMiddleware {
    private let scheme: String
    private let tokenProvider: @Sendable () async throws -> String?

    /// Creates middleware. A nil or empty token leaves authorization unchanged.
    public init(
        scheme: String = "Bearer",
        tokenProvider: @escaping @Sendable () async throws -> String?
    ) {
        self.scheme = scheme
        self.tokenProvider = tokenProvider
    }

    /// Resolves a token for each operation before forwarding the request.
    public func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        if let token = try await tokenProvider(), !token.isEmpty {
            request.headerFields[.authorization] = "\(scheme) \(token)"
        }
        return try await next(request, body, baseURL)
    }
}
