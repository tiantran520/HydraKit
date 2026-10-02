import Foundation

/// A request interceptor that applies static HTTP headers.
public struct HeaderInterceptor: RequestInterceptor {
    /// The interceptor identifier.
    public let id: String

    private let headers: HTTPHeaders
    private let overwritesExistingValues: Bool

    /// Creates a header interceptor.
    /// - Parameters:
    ///   - id: The interceptor identifier.
    ///   - headers: The headers to add.
    ///   - overwritesExistingValues: Whether existing header values should be replaced.
    public init(
        id: String = "headers",
        headers: HTTPHeaders,
        overwritesExistingValues: Bool = true
    ) {
        self.id = id
        self.headers = headers
        self.overwritesExistingValues = overwritesExistingValues
    }

    /// Adds configured headers to the request.
    public func intercept(_ request: URLRequest) async throws -> URLRequest {
        var request = request

        headers.forEach { name, value in
            if overwritesExistingValues || request.value(forHTTPHeaderField: name) == nil {
                request.setValue(value, forHTTPHeaderField: name)
            }
        }

        return request
    }
}
