import Foundation

/// A type that can inspect or mutate an outgoing URL request.
public protocol RequestInterceptor: Sendable {
    /// A stable identifier used for runtime removal.
    var id: String { get }

    /// Intercepts an outgoing request.
    /// - Parameter request: The request produced by the caller or request builder.
    /// - Returns: The request that should be passed to the next interceptor.
    func intercept(_ request: URLRequest) async throws -> URLRequest
}
