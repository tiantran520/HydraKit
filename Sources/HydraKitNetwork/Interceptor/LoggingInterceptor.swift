import Foundation
import HydraKit

/// An interceptor that logs outgoing requests and incoming responses.
public struct LoggingInterceptor: RequestInterceptor, ResponseInterceptor {
    /// The interceptor identifier.
    public let id: String

    private let logger: any Logger
    private let category: LogCategory

    /// Creates a logging interceptor.
    /// - Parameters:
    ///   - id: The interceptor identifier.
    ///   - logger: The logger used to record messages.
    ///   - category: The log category.
    public init(
        id: String = "logging",
        logger: any Logger,
        category: LogCategory = .network
    ) {
        self.id = id
        self.logger = logger
        self.category = category
    }

    /// Logs and forwards an outgoing request.
    public func intercept(_ request: URLRequest) async throws -> URLRequest {
        let method = request.httpMethod ?? "UNKNOWN"
        let url = request.url?.absoluteString ?? "<nil>"
        logger.info("Request \(method) \(url)", category: category)
        return request
    }

    /// Logs and forwards an incoming response.
    public func intercept(_ response: Response<Data>) async throws -> Response<Data> {
        let url = response.url?.absoluteString ?? "<nil>"
        logger.info("Response \(response.status.rawValue) \(url)", category: category)
        return response
    }
}
