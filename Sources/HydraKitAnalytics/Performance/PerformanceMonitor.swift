import Foundation

/// Measures operation duration.
public actor PerformanceMonitor {
    private var starts: [String: ContinuousClock.Instant] = [:]
    private let clock = ContinuousClock()

    /// Creates a performance monitor.
    public init() {}

    /// Starts a metric.
    public func start(_ name: String) {
        starts[name] = clock.now
    }

    /// Stops a metric and returns elapsed seconds.
    public func stop(_ name: String) -> TimeInterval? {
        guard let start = starts.removeValue(forKey: name) else { return nil }
        let duration = start.duration(to: clock.now)
        return Double(duration.components.seconds) + Double(duration.components.attoseconds) / 1_000_000_000_000_000_000
    }
}
