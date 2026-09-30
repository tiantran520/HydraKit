import Foundation

/// A side effect that can emit actions.
public struct Effect<Action: ViewAction>: Sendable {
    private let operation: @Sendable (@escaping @Sendable (Action) async -> Void) async -> Void

    /// Creates an effect.
    public init(operation: @escaping @Sendable (@escaping @Sendable (Action) async -> Void) async -> Void) {
        self.operation = operation
    }

    /// Runs the effect.
    public func run(send: @escaping @Sendable (Action) async -> Void) async {
        await operation(send)
    }

    /// Creates an effect that sends one action.
    public static func send(_ action: Action) -> Effect<Action> {
        Effect { send in
            await send(action)
        }
    }

    /// Creates an effect that does nothing.
    public static var none: Effect<Action> {
        Effect { _ in }
    }
}
