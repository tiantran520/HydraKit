import Foundation

/// Dispatches typed actions to a handler.
@MainActor
public final class HKActionDispatcher<Action: ViewAction> {
    private let handler: @MainActor (Action) async -> Void

    /// Creates an action dispatcher.
    public init(handler: @escaping @MainActor (Action) async -> Void) {
        self.handler = handler
    }

    /// Dispatches an action asynchronously.
    public func dispatch(_ action: Action) {
        Task { @MainActor in
            await handler(action)
        }
    }

    /// Dispatches an action and awaits completion.
    public func dispatchAndWait(_ action: Action) async {
        await handler(action)
    }
}
