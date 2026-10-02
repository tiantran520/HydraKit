import Foundation

/// A type-erased route value.
public struct AnyRoute: Route {
    /// The stable identifier for this route.
    public let routeIdentifier: RouteIdentifier
    private let storage: any Hashable & Sendable
    private let equals: @Sendable (AnyRoute) -> Bool
    private let hashInto: @Sendable (inout Hasher) -> Void

    /// Creates a type-erased route.
    public init<R: Route>(_ route: R) {
        self.routeIdentifier = route.routeIdentifier
        self.storage = route
        self.equals = { other in
            other.storage as? R == route
        }
        self.hashInto = { hasher in
            route.hash(into: &hasher)
        }
    }

    /// Creates a simple route from an identifier.
    public init(_ identifier: RouteIdentifier) {
        self.routeIdentifier = identifier
        self.storage = identifier
        self.equals = { other in
            other.routeIdentifier == identifier
        }
        self.hashInto = { hasher in
            identifier.hash(into: &hasher)
        }
    }

    /// Returns the wrapped route when it matches the requested type.
    public func route<R: Route>(as type: R.Type = R.self) -> R? {
        storage as? R
    }

    /// Compares two type-erased routes.
    public static func == (lhs: AnyRoute, rhs: AnyRoute) -> Bool {
        lhs.equals(rhs)
    }

    /// Hashes the route.
    public func hash(into hasher: inout Hasher) {
        hashInto(&hasher)
    }
}
