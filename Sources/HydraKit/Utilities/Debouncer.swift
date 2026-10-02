import Foundation

/// Schedules an action after a quiet period, cancelling earlier scheduled actions.
public final class HKDebouncer {
    private let delay: TimeInterval
    private let queue: DispatchQueue
    private var workItem: DispatchWorkItem?

    /// Creates a debouncer.
    /// - Parameters:
    ///   - delay: The quiet period before the action runs.
    ///   - queue: The queue on which the action runs.
    public init(delay: TimeInterval, queue: DispatchQueue = .main) {
        self.delay = delay
        self.queue = queue
    }

    /// Schedules an action, cancelling any previously scheduled action.
    /// - Parameter action: The action to run after the delay.
    public func schedule(_ action: @escaping () -> Void) {
        workItem?.cancel()

        let item = DispatchWorkItem(block: action)
        workItem = item
        queue.asyncAfter(deadline: .now() + delay, execute: item)
    }

    /// Cancels any pending action.
    public func cancel() {
        workItem?.cancel()
        workItem = nil
    }
}
