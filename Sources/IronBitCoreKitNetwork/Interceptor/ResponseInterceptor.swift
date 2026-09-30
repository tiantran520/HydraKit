import Foundation

/// A type that can inspect or mutate an incoming network response.
public protocol ResponseInterceptor: Sendable {
    /// A stable identifier used for runtime removal.
    var id: String { get }

    /// Intercepts an incoming response.
    /// - Parameter response: The response produced by the network client.
    /// - Returns: The response that should be passed to the next interceptor.
    func intercept(_ response: Response<Data>) async throws -> Response<Data>
}
