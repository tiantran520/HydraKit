import Foundation

/// Timeout values used when creating URL session configurations and requests.
public struct TimeoutConfiguration: Equatable, Sendable {
    /// The timeout interval for an individual request.
    public let requestTimeout: TimeInterval

    /// The timeout interval for the entire resource load.
    public let resourceTimeout: TimeInterval

    /// Creates a timeout configuration.
    /// - Parameters:
    ///   - requestTimeout: The timeout interval for an individual request.
    ///   - resourceTimeout: The timeout interval for the entire resource load.
    public init(
        requestTimeout: TimeInterval = 30,
        resourceTimeout: TimeInterval = 60
    ) {
        self.requestTimeout = requestTimeout
        self.resourceTimeout = resourceTimeout
    }
}

public extension TimeoutConfiguration {
    /// A default timeout configuration suitable for most API requests.
    static let `default` = TimeoutConfiguration()

    /// A shorter timeout configuration for latency-sensitive requests.
    static let short = TimeoutConfiguration(requestTimeout: 10, resourceTimeout: 20)

    /// A longer timeout configuration for upload or download style requests.
    static let long = TimeoutConfiguration(requestTimeout: 60, resourceTimeout: 180)
}
