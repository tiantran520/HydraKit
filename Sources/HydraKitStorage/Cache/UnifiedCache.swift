import Foundation

/// A cache that combines fast memory lookup with async persistent storage.
public final class HKUnifiedCache<Value: Codable & Sendable>: @unchecked Sendable {
    private let memoryCache: HKLRUCache<String, Value>
    private let persistentStore: (any KeyValueStore)?

    /// Creates a unified cache.
    public init(
        memoryCapacity: Int = 100,
        persistentStore: (any KeyValueStore)? = nil
    ) {
        self.memoryCache = HKLRUCache(capacity: memoryCapacity)
        self.persistentStore = persistentStore
    }

    /// Reads a cached value.
    public func value(for key: StorageKey<Value>) async throws -> Value? {
        if let value = memoryCache.value(for: key.rawValue) {
            return value
        }

        let value = try await persistentStore?.value(for: key)
        if let value {
            memoryCache.setValue(value, for: key.rawValue)
        }
        return value
    }

    /// Stores a cached value.
    public func setValue(_ value: Value?, for key: StorageKey<Value>) async throws {
        if let value {
            memoryCache.setValue(value, for: key.rawValue)
        } else {
            memoryCache.removeValue(for: key.rawValue)
        }
        try await persistentStore?.setValue(value, for: key)
    }

    /// Removes a cached value.
    public func removeValue(for key: StorageKey<Value>) async throws {
        memoryCache.removeValue(for: key.rawValue)
        try await persistentStore?.removeValue(for: key)
    }
}
