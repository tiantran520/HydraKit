import Foundation

/// A coordinator that owns a navigation flow.
@MainActor
public protocol Coordinator: AnyObject {
    /// The router controlled by the coordinator.
    var router: any Router { get }
    /// Current lifecycle state.
    var lifecycle: CoordinatorLifecycle { get }

    /// Starts the flow.
    func start()
    /// Stops the flow and releases child coordinators.
    func stop()
}
