import Foundation

public extension URLSessionConfiguration {
    /// Creates a default configuration for IronBitCoreKit network clients.
    /// - Parameter timeoutConfiguration: The timeout values applied to the session.
    /// - Returns: A configured URL session configuration.
    static func ironBitDefault(
        timeoutConfiguration: TimeoutConfiguration = .default
    ) -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutConfiguration.requestTimeout
        configuration.timeoutIntervalForResource = timeoutConfiguration.resourceTimeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.waitsForConnectivity = true
        configuration.httpAdditionalHeaders = [
            HTTPHeaders.accept: HTTPHeaders.applicationJSON,
            HTTPHeaders.contentType: HTTPHeaders.applicationJSON
        ]
        return configuration
    }

    /// Creates an ephemeral configuration for tests and previews.
    /// - Parameter timeoutConfiguration: The timeout values applied to the session.
    /// - Returns: A configured ephemeral URL session configuration.
    static func ironBitEphemeral(
        timeoutConfiguration: TimeoutConfiguration = .default
    ) -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = timeoutConfiguration.requestTimeout
        configuration.timeoutIntervalForResource = timeoutConfiguration.resourceTimeout
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.waitsForConnectivity = false
        configuration.httpAdditionalHeaders = [
            HTTPHeaders.accept: HTTPHeaders.applicationJSON,
            HTTPHeaders.contentType: HTTPHeaders.applicationJSON
        ]
        return configuration
    }
}
