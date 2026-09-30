import Foundation

/// Handles effects and forwards emitted actions.
@MainActor
public final class EffectHandler<Action: ViewAction> {
    private let dispatcher: ActionDispatcher<Action>

    /// Creates an effect handler.
    public init(dispatcher: ActionDispatcher<Action>) {
        self.dispatcher = dispatcher
    }

    /// Runs an effect.
    @discardableResult
    public func handle(_ effect: Effect<Action>) -> CancellableTask {
        let task = Task { [self] in
            await effect.run { action in
                await MainActor.run {
                    self.dispatcher.dispatch(action)
                }
            }
        }
        return CancellableTask(task)
    }
}
