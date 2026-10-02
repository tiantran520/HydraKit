import Foundation

/// A base protocol for MVVM view models.
@MainActor
public protocol ViewModel: ObservableObject {
    /// The action type accepted by the view model.
    associatedtype Action: ViewAction

    /// Handles an action from the view.
    func send(_ action: Action)
}
