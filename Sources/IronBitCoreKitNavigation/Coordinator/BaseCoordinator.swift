import Foundation

/// A base coordinator implementation with child management.
@MainActor
open class BaseCoordinator: Coordinator {
    /// The router controlled by the coordinator.
    public let router: any Router
    /// Current lifecycle state.
    public private(set) var lifecycle: CoordinatorLifecycle = .idle
    private var children: [ObjectIdentifier: any Coordinator] = [:]

    /// Creates a coordinator with a default navigation router.
    public convenience init() {
        self.init(router: NavigationRouter())
    }

    /// Creates a coordinator.
    public init(router: any Router) {
        self.router = router
    }

    /// Starts the coordinator.
    open func start() {
        lifecycle = .started
    }

    /// Stops the coordinator and all children.
    open func stop() {
        children.values.forEach { $0.stop() }
        children.removeAll()
        lifecycle = .stopped
    }

    /// Adds a child coordinator.
    public func addChild(_ coordinator: any Coordinator) {
        children[ObjectIdentifier(coordinator)] = coordinator
    }

    /// Removes a child coordinator.
    public func removeChild(_ coordinator: any Coordinator) {
        children.removeValue(forKey: ObjectIdentifier(coordinator))
    }
}
