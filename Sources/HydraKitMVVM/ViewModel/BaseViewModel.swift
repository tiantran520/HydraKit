import Foundation

/// A base observable view model with task management.
@MainActor
open class HKBaseViewModel<Action: ViewAction>: ViewModel {
    private var tasks: [HKCancellableTask] = []

    /// Creates a base view model.
    public init() {}

    /// Handles an action from the view.
    open func send(_ action: Action) {
        // Subclasses override this method.
    }

    /// Stores a cancellable task owned by the view model.
    public func store(_ task: HKCancellableTask) {
        tasks.append(task)
    }

    /// Cancels all owned tasks.
    public func cancelTasks() {
        tasks.forEach { $0.cancel() }
        tasks.removeAll()
    }

    deinit {
        tasks.forEach { $0.cancel() }
    }
}
