import Foundation

/// A storage abstraction for key-value persistence.
public protocol KeyValueStore: Storage {
    /// Returns whether a value exists for a raw key.
    /// - Parameter key: The raw key.
    func contains(_ key: String) async -> Bool

    /// Removes every value managed by the store when supported.
    func removeAll() async throws
}
