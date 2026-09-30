import Foundation

/// A lightweight view model for previews and tests.
@MainActor
public final class MockViewModel<Value: Sendable, Action: ViewAction>: BaseViewModel<Action> {
    /// Observable state container.
    public let stateContainer: StateContainer<Value>
    /// Captured actions.
    public private(set) var receivedActions: [Action] = []
    private let actionHandler: (@MainActor (Action) -> Void)?

    /// Creates a mock view model.
    public init(
        state: ViewState<Value> = .idle,
        actionHandler: (@MainActor (Action) -> Void)? = nil
    ) {
        self.stateContainer = StateContainer(state)
        self.actionHandler = actionHandler
        super.init()
    }

    /// Handles and captures an action.
    public override func send(_ action: Action) {
        receivedActions.append(action)
        actionHandler?(action)
    }

    /// Updates the mock state.
    public func setState(_ state: ViewState<Value>) {
        stateContainer.setState(state)
    }
}
