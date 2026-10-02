import Foundation

/// A step inside a linear or branching flow.
public protocol FlowStep: Hashable, Identifiable, Sendable {
    /// The route associated with this step.
    var route: AnyRoute { get }
}

public extension FlowStep {
    /// The default flow step identifier.
    var id: RouteIdentifier { route.routeIdentifier }
}
