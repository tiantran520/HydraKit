import Foundation

/// A type that can be pushed, presented or resolved by a router.
public protocol Route: Hashable, Identifiable, Sendable {
    /// The stable identifier for this route.
    var routeIdentifier: RouteIdentifier { get }
}

public extension Route {
    /// The default identifiable value for a route.
    var id: RouteIdentifier { routeIdentifier }
}
