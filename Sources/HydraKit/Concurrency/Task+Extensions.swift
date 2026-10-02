import Foundation

/// Convenience helpers for Swift concurrency tasks.
public extension Task where Success == Never, Failure == Never {
    /// Suspends the current task for a number of seconds.
    /// - Parameter seconds: The number of seconds to sleep.
    static func sleep(seconds: TimeInterval) async throws {
        let nanoseconds = UInt64(max(0, seconds) * 1_000_000_000)
        try await Task.sleep(nanoseconds: nanoseconds)
    }
}

/// Convenience helpers for throwing tasks.
public extension Task where Failure == Error {
    /// Creates a task that starts after a delay.
    /// - Parameters:
    ///   - seconds: The delay before running the operation.
    ///   - priority: The task priority.
    ///   - operation: The operation to execute after the delay.
    /// - Returns: A task representing the delayed operation.
    static func delayed(
        seconds: TimeInterval,
        priority: TaskPriority? = nil,
        operation: @escaping @Sendable () async throws -> Success
    ) -> Task<Success, Error> {
        Task(priority: priority) {
            try await Task<Never, Never>.sleep(seconds: seconds)
            return try await operation()
        }
    }
}
