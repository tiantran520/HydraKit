import Foundation

/// A cache entry with an optional expiration date.
public struct CacheEntry<Value: Sendable>: Sendable {
    /// The cached value.
    public let value: Value

    /// The entry creation date.
    public let createdAt: Date

    /// The optional expiration date.
    public let expiresAt: Date?

    /// Creates a cache entry.
    public init(value: Value, createdAt: Date = Date(), expiresAt: Date? = nil) {
        self.value = value
        self.createdAt = createdAt
        self.expiresAt = expiresAt
    }

    /// A Boolean value indicating whether the entry has expired.
    public var isExpired: Bool {
        expiresAt.map { $0 <= Date() } ?? false
    }
}
