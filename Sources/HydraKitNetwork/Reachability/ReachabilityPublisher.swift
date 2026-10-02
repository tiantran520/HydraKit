import Foundation

#if canImport(Combine)
import Combine

/// Publishes reachability changes from a network monitor.
public final class HKReachabilityPublisher {
    private let monitor: HKNetworkMonitor
    private let subject: CurrentValueSubject<HKConnectionStatus, Never>

    /// Creates a reachability publisher.
    /// - Parameter monitor: The monitor used to observe network changes.
    public init(monitor: HKNetworkMonitor = HKNetworkMonitor()) {
        self.monitor = monitor
        self.subject = CurrentValueSubject(monitor.currentStatus)
    }

    /// A publisher emitting connection status values.
    public var publisher: AnyPublisher<HKConnectionStatus, Never> {
        subject.eraseToAnyPublisher()
    }

    /// Starts publishing reachability changes.
    public func start() {
        monitor.start { [subject] status in
            subject.send(status)
        }
    }

    /// Stops publishing reachability changes.
    public func stop() {
        monitor.stop()
    }
}
#endif
