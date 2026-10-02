import Foundation

/// Simulates network latency in tests and previews.
public struct NetworkDelaySimulator: Sendable {
    /// The delay interval in seconds.
    public let delay: TimeInterval

    /// Creates a delay simulator.
    /// - Parameter delay: The delay interval in seconds.
    public init(delay: TimeInterval = 0) {
        self.delay = max(0, delay)
    }

    /// Suspends the current task for the configured delay.
    public func wait() async throws {
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
    }
}
