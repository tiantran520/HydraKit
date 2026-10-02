import Foundation

/// A request interceptor that attaches an authorization header.
public struct AuthInterceptor: RequestInterceptor {
    /// The interceptor identifier.
    public let id: String

    private let tokenProvider: @Sendable () async throws -> String?
    private let scheme: String
    private let headerName: String

    /// Creates an authentication interceptor.
    /// - Parameters:
    ///   - id: The interceptor identifier.
    ///   - scheme: The authorization scheme.
    ///   - headerName: The authorization header name.
    ///   - tokenProvider: A closure that returns the current token.
    public init(
        id: String = "auth",
        scheme: String = "Bearer",
        headerName: String = HTTPHeaders.authorization,
        tokenProvider: @escaping @Sendable () async throws -> String?
    ) {
        self.id = id
        self.scheme = scheme
        self.headerName = headerName
        self.tokenProvider = tokenProvider
    }

    /// Adds the authorization header when a token is available.
    public func intercept(_ request: URLRequest) async throws -> URLRequest {
        guard let token = try await tokenProvider(), !token.isEmpty else {
            return request
        }

        var request = request
        request.setValue("\(scheme) \(token)", forHTTPHeaderField: headerName)
        return request
    }
}
