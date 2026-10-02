import Foundation

/// A cache for raw network response data.
public protocol NetworkCache: Sendable {
    /// Reads cached data for a key.
    /// - Parameter key: The cache key.
    /// - Returns: Cached data when present.
    func data(forKey key: String) async throws -> Data?

    /// Stores data for a key.
    /// - Parameters:
    ///   - data: The data to cache.
    ///   - key: The cache key.
    func store(_ data: Data, forKey key: String) async throws

    /// Removes cached data for a key.
    /// - Parameter key: The cache key.
    func removeData(forKey key: String) async throws

    /// Removes all cached data.
    func removeAll() async throws
}
