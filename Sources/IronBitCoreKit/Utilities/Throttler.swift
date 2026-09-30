import Foundation

/// Limits an action so it runs at most once during an interval.
public final class Throttler {
    private let interval: TimeInterval
    private let queue: DispatchQueue
    private var lastRunDate: Date?
    private var pendingWorkItem: DispatchWorkItem?

    /// Creates a throttler.
    /// - Parameters:
    ///   - interval: The minimum interval between action executions.
    ///   - queue: The queue on which actions run.
    public init(interval: TimeInterval, queue: DispatchQueue = .main) {
        self.interval = interval
        self.queue = queue
    }

    /// Runs an action immediately when possible, otherwise schedules it for later.
    /// - Parameter action: The action to throttle.
    public func run(_ action: @escaping () -> Void) {
        pendingWorkItem?.cancel()

        let now = Date()
        let elapsed = lastRunDate.map { now.timeIntervalSince($0) } ?? interval
        let remaining = max(0, interval - elapsed)

        let item = DispatchWorkItem { [weak self] in
            self?.lastRunDate = Date()
            action()
        }

        pendingWorkItem = item
        queue.asyncAfter(deadline: .now() + remaining, execute: item)
    }

    /// Cancels any pending throttled action.
    public func cancel() {
        pendingWorkItem?.cancel()
        pendingWorkItem = nil
    }
}
