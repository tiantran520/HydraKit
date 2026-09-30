import Foundation

/// A small wrapper around a cancellable Swift task.
public final class CancellableTask: @unchecked Sendable {
    private let cancelClosure: @Sendable () -> Void

    /// Creates a cancellable task wrapper.
    public init<Success: Sendable>(_ task: Task<Success, Never>) {
        self.cancelClosure = {
            task.cancel()
        }
    }

    /// Creates a custom cancellable task.
    public init(cancel: @escaping @Sendable () -> Void) {
        self.cancelClosure = cancel
    }

    /// Cancels the task.
    public func cancel() {
        cancelClosure()
    }
}
