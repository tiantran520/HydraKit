import Foundation
import SwiftUI

/// A default observable router for SwiftUI navigation.
@MainActor
public final class NavigationRouter: ObservableObject, Router {
    /// The route stack.
    @Published public private(set) var path: [AnyRoute]
    /// The currently presented sheet route.
    @Published public private(set) var presentedRoute: AnyRoute?

    /// Creates a navigation router.
    public init(path: [AnyRoute] = [], presentedRoute: AnyRoute? = nil) {
        self.path = path
        self.presentedRoute = presentedRoute
    }

    /// Pushes a route onto the stack.
    public func push<R: Route>(_ route: R) {
        path.append(AnyRoute(route))
    }

    /// Replaces the current stack.
    public func setPath(_ routes: [AnyRoute]) {
        path = routes
    }

    /// Pops the top route.
    public func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    /// Pops all routes.
    public func popToRoot() {
        path.removeAll()
    }

    /// Presents a route modally.
    public func present<R: Route>(_ route: R) {
        presentedRoute = AnyRoute(route)
    }

    /// Dismisses the presented route.
    public func dismiss() {
        presentedRoute = nil
    }
}
