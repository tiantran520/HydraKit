import Foundation
import Network

/// Monitors network reachability using `NWPathMonitor`.
public final class NetworkMonitor: @unchecked Sendable {
    private let monitor: NWPathMonitor
    private let queue: DispatchQueue
    private let lock = NSLock()
    private var statusHandler: (@Sendable (ConnectionStatus) -> Void)?
    private var isStarted = false

    /// The latest known connection status.
    public private(set) var currentStatus: ConnectionStatus = .unknown

    /// Creates a network monitor.
    /// - Parameters:
    ///   - monitor: The path monitor to use.
    ///   - queue: The queue on which reachability updates are delivered.
    public init(
        monitor: NWPathMonitor = NWPathMonitor(),
        queue: DispatchQueue = DispatchQueue(label: "IronBitCoreKitNetwork.NetworkMonitor")
    ) {
        self.monitor = monitor
        self.queue = queue
    }

    deinit {
        stop()
    }

    /// Starts monitoring network reachability.
    /// - Parameter handler: A closure called whenever the connection status changes.
    public func start(handler: (@Sendable (ConnectionStatus) -> Void)? = nil) {
        lock.withLock {
            statusHandler = handler

            guard !isStarted else {
                return
            }

            monitor.pathUpdateHandler = { [weak self] path in
                self?.updateStatus(ConnectionStatus(path: path))
            }
            monitor.start(queue: queue)
            isStarted = true
        }
    }

    /// Stops monitoring network reachability.
    public func stop() {
        lock.withLock {
            guard isStarted else {
                return
            }

            monitor.cancel()
            isStarted = false
            statusHandler = nil
        }
    }

    private func updateStatus(_ status: ConnectionStatus) {
        let handler = lock.withLock {
            currentStatus = status
            return statusHandler
        }
        handler?(status)
    }
}
