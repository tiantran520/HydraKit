import Foundation

/// Lifecycle states for a coordinator.
public enum CoordinatorLifecycle: Sendable {
    /// The coordinator has not started.
    case idle
    /// The coordinator is active.
    case started
    /// The coordinator has stopped.
    case stopped
}
