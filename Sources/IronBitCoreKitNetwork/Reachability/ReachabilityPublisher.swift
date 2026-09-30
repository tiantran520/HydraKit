import Foundation

#if canImport(Combine)
import Combine

/// Publishes reachability changes from a network monitor.
public final class ReachabilityPublisher {
    private let monitor: NetworkMonitor
    private let subject: CurrentValueSubject<ConnectionStatus, Never>

    /// Creates a reachability publisher.
    /// - Parameter monitor: The monitor used to observe network changes.
    public init(monitor: NetworkMonitor = NetworkMonitor()) {
        self.monitor = monitor
        self.subject = CurrentValueSubject(monitor.currentStatus)
    }

    /// A publisher emitting connection status values.
    public var publisher: AnyPublisher<ConnectionStatus, Never> {
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
