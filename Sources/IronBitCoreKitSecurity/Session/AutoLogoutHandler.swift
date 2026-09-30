import Foundation

/// Handles automatic logout after inactivity.
public final class AutoLogoutHandler: @unchecked Sendable {
    private let timeout: Duration
    private let onLogout: @Sendable () async -> Void
    private var task: Task<Void, Never>?

    /// Creates an auto logout handler.
    public init(timeout: Duration, onLogout: @escaping @Sendable () async -> Void) {
        self.timeout = timeout
        self.onLogout = onLogout
    }

    /// Resets the inactivity timer.
    public func reset() {
        task?.cancel()
        task = Task {
            try? await Task.sleep(for: timeout)
            guard !Task.isCancelled else { return }
            await onLogout()
        }
    }

    /// Cancels the inactivity timer.
    public func cancel() {
        task?.cancel()
        task = nil
    }
}
