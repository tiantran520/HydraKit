import Foundation

/// A cancellable wrapper around an asynchronous network request.
public final class HKRequestTask<Value> {
    private let task: Task<Response<Value>, Error>

    /// Creates a request task.
    /// - Parameter operation: The asynchronous operation represented by the task.
    public init(
        operation: @escaping @Sendable () async throws -> Response<Value>
    ) {
        self.task = Task {
            try await operation()
        }
    }

    /// A Boolean value indicating whether the underlying task has been cancelled.
    public var isCancelled: Bool {
        task.isCancelled
    }

    /// Cancels the underlying request task.
    public func cancel() {
        task.cancel()
    }

    /// Waits for the request result.
    /// - Returns: The network response.
    public func value() async throws -> Response<Value> {
        try await task.value
    }
}
