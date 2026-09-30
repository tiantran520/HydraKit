import Foundation

/// An observable container for a single view state value.
@MainActor
public final class StateContainer<Value: Sendable>: ObservableObject {
    /// The current state.
    @Published public private(set) var state: ViewState<Value>

    /// Creates a state container.
    public init(_ state: ViewState<Value> = .idle) {
        self.state = state
    }

    /// Updates the current state.
    public func setState(_ state: ViewState<Value>) {
        self.state = state
    }

    /// Sets a loaded value.
    public func setLoaded(_ value: Value) {
        state = .loaded(value)
    }

    /// Sets an error state.
    public func setError(_ error: any Error) {
        state = .error(error)
    }
}
