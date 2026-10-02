import Foundation

/// A navigation router abstraction.
@MainActor
public protocol Router: AnyObject {
    /// The route stack.
    var path: [AnyRoute] { get }
    /// The currently presented sheet route.
    var presentedRoute: AnyRoute? { get }

    /// Pushes a route onto the stack.
    func push<R: Route>(_ route: R)
    /// Replaces the current stack.
    func setPath(_ routes: [AnyRoute])
    /// Pops the top route.
    func pop()
    /// Pops all routes.
    func popToRoot()
    /// Presents a route modally.
    func present<R: Route>(_ route: R)
    /// Dismisses the presented route.
    func dismiss()
}
