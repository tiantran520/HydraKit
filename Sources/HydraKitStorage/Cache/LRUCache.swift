import Foundation

/// A simple least-recently-used in-memory cache.
public final class HKLRUCache<Key: Hashable & Sendable, Value: Sendable>: @unchecked Sendable {
    private let capacity: Int
    private var storage: [Key: CacheEntry<Value>] = [:]
    private var order: [Key] = []
    private let lock = NSLock()

    /// Creates an LRU cache.
    public init(capacity: Int) {
        self.capacity = max(1, capacity)
    }

    /// Reads a cached value.
    public func value(for key: Key) -> Value? {
        lock.withLock {
            guard let entry = storage[key], !entry.isExpired else {
                storage.removeValue(forKey: key)
                order.removeAll { $0 == key }
                return nil
            }
            touch(key)
            return entry.value
        }
    }

    /// Stores a value.
    public func setValue(_ value: Value, for key: Key, expiresAt: Date? = nil) {
        lock.withLock {
            storage[key] = CacheEntry(value: value, expiresAt: expiresAt)
            touch(key)
            evictIfNeeded()
        }
    }

    /// Removes a cached value.
    public func removeValue(for key: Key) {
        lock.withLock {
            storage.removeValue(forKey: key)
            order.removeAll { $0 == key }
        }
    }

    /// Removes all values.
    public func removeAll() {
        lock.withLock {
            storage.removeAll()
            order.removeAll()
        }
    }

    private func touch(_ key: Key) {
        order.removeAll { $0 == key }
        order.append(key)
    }

    private func evictIfNeeded() {
        while storage.count > capacity, let key = order.first {
            storage.removeValue(forKey: key)
            order.removeFirst()
        }
    }
}
