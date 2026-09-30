import Foundation

/// A stable identifier for a navigation route.
public struct RouteIdentifier: Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    /// The raw route identifier.
    public let rawValue: String

    /// Creates a route identifier.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    /// Creates a route identifier from a string literal.
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension RouteIdentifier: CustomStringConvertible {
    /// A readable route identifier.
    public var description: String { rawValue }
}
