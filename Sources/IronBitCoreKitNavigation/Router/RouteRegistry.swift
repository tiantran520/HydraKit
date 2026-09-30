import SwiftUI

/// A registry that maps route identifiers to SwiftUI destinations.
@MainActor
public final class RouteRegistry {
    /// A registered route builder.
    public typealias Builder = @MainActor (AnyRoute) -> AnyView

    private var builders: [RouteIdentifier: Builder]

    /// Creates a route registry.
    public init(builders: [RouteIdentifier: Builder] = [:]) {
        self.builders = builders
    }

    /// Registers a destination builder for a route type.
    public func register<R: Route>(_ routeType: R.Type, identifier: RouteIdentifier, builder: @escaping @MainActor (R) -> AnyView) {
        builders[identifier] = { anyRoute in
            guard let route = anyRoute.route(as: R.self) else {
                return AnyView(EmptyView())
            }
            return builder(route)
        }
    }

    /// Registers a destination builder for an identifier.
    public func register(identifier: RouteIdentifier, builder: @escaping Builder) {
        builders[identifier] = builder
    }

    /// Removes a destination builder.
    public func unregister(identifier: RouteIdentifier) {
        builders.removeValue(forKey: identifier)
    }

    /// Builds a destination for a route.
    public func destination(for route: AnyRoute) -> AnyView {
        builders[route.routeIdentifier]?(route) ?? AnyView(EmptyView())
    }
}
