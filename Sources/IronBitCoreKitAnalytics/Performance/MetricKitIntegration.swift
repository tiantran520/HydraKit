import Foundation

/// Placeholder integration point for MetricKit payload handling.
public protocol MetricKitIntegration: Sendable {
    /// Handles a platform metric payload.
    func handleMetricPayload(_ payload: AnySendable) async
}

/// A type-erased sendable value wrapper.
public struct AnySendable: @unchecked Sendable {
    /// Wrapped value.
    public let value: Any

    /// Creates a wrapper.
    public init(_ value: Any) {
        self.value = value
    }
}
