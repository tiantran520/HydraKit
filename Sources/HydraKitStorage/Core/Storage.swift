import Foundation

/// A generic asynchronous storage abstraction.
public protocol Storage: Sendable {
    /// Reads a value for a type-safe key.
    /// - Parameter key: The key to read.
    /// - Returns: The stored value.
    func value<Value: Codable & Sendable>(for key: StorageKey<Value>) async throws -> Value?

    /// Stores a value for a type-safe key.
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: The key to write.
    func setValue<Value: Codable & Sendable>(_ value: Value?, for key: StorageKey<Value>) async throws

    /// Removes a value for a type-safe key.
    /// - Parameter key: The key to remove.
    func removeValue<Value>(for key: StorageKey<Value>) async throws
}
