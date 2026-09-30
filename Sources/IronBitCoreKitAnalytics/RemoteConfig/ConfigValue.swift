import Foundation

/// A remote configuration value.
public enum ConfigValue: Codable, Hashable, Sendable {
    /// String value.
    case string(String)
    /// Boolean value.
    case bool(Bool)
    /// Integer value.
    case int(Int)
    /// Double value.
    case double(Double)
    /// Missing value.
    case none

    /// Returns a string representation when possible.
    public var stringValue: String? {
        if case let .string(value) = self { return value }
        return nil
    }

    /// Returns a boolean representation when possible.
    public var boolValue: Bool? {
        if case let .bool(value) = self { return value }
        return nil
    }
}
