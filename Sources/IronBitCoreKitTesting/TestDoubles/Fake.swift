import Foundation

/// A lightweight in-memory fake storage useful for tests.
public final class Fake<Key: Hashable, Value> {
    private let lock = NSLock()
    private var storage: [Key: Value]

    /// Creates an in-memory fake with optional seed values.
    /// - Parameter storage: Initial key-value pairs.
    public init(storage: [Key: Value] = [:]) {
        self.storage = storage
    }

    /// Reads a value for a key.
    /// - Parameter key: The key to read.
    /// - Returns: The stored value, or `nil`.
    public func value(for key: Key) -> Value? {
        lock.withLock {
            storage[key]
        }
    }

    /// Stores a value for a key.
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: The key to associate with the value.
    public func setValue(_ value: Value, for key: Key) {
        lock.withLock {
            storage[key] = value
        }
    }

    /// Removes a value for a key.
    /// - Parameter key: The key to remove.
    public func removeValue(for key: Key) {
        lock.withLock {
            _ = storage.removeValue(forKey: key)
        }
    }

    /// Removes all stored values.
    public func removeAll() {
        lock.withLock {
            storage.removeAll()
        }
    }
}
