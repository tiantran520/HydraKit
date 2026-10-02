import Foundation

/// Convenience helpers for actor-isolated work.
public extension Actor {
    /// Performs a synchronous operation while isolated to the actor.
    /// - Parameter operation: The operation to perform with isolated actor access.
    /// - Returns: The operation result.
    func performInIsolation<Output>(
        _ operation: @Sendable (isolated Self) throws -> Output
    ) async rethrows -> Output {
        try operation(self)
    }
}
