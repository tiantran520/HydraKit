import Foundation

/// Handles effects and forwards emitted actions.
@MainActor
public final class HKEffectHandler<Action: ViewAction> {
    private let dispatcher: HKActionDispatcher<Action>

    /// Creates an effect handler.
    public init(dispatcher: HKActionDispatcher<Action>) {
        self.dispatcher = dispatcher
    }

    /// Runs an effect.
    @discardableResult
    public func handle(_ effect: Effect<Action>) -> HKCancellableTask {
        let task = Task { [self] in
            await effect.run { action in
                await MainActor.run {
                    self.dispatcher.dispatch(action)
                }
            }
        }
        return HKCancellableTask(task)
    }
}
