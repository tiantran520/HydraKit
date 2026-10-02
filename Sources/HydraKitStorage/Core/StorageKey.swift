import Foundation

/// A type-safe storage key for values of a specific type.
public struct StorageKey<Value>: RawRepresentable, Hashable, Sendable {
    /// The raw key string.
    public let rawValue: String

    /// Creates a storage key.
    /// - Parameter rawValue: The raw key string.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension StorageKey {
    /// Creates a storage key from a string.
    /// - Parameter value: The raw key string.
    init(_ value: String) {
        self.init(rawValue: value)
    }
}
