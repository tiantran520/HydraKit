import Foundation

/// A generic loading state for MVVM views.
public enum ViewState<Value: Sendable>: Sendable {
    /// The view has not started loading.
    case idle
    /// The view is loading data.
    case loading
    /// The view has loaded data.
    case loaded(Value)
    /// The view failed with an error.
    case error(any Error)
}

public extension ViewState {
    /// Returns the loaded value when available.
    var value: Value? {
        if case let .loaded(value) = self {
            return value
        }
        return nil
    }

    /// Returns whether the state is loading.
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
}
