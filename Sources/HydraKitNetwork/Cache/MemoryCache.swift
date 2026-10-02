import Foundation

/// An in-memory network cache backed by `NSCache`.
public final class HKMemoryCache: NetworkCache, @unchecked Sendable {
    private let cache = NSCache<NSString, NSData>()

    /// Creates an in-memory cache.
    /// - Parameter countLimit: The maximum number of cached entries.
    public init(countLimit: Int = 0) {
        cache.countLimit = countLimit
    }

    /// Reads cached data for a key.
    public func data(forKey key: String) async throws -> Data? {
        cache.object(forKey: key as NSString) as Data?
    }

    /// Stores data for a key.
    public func store(_ data: Data, forKey key: String) async throws {
        cache.setObject(data as NSData, forKey: key as NSString)
    }

    /// Removes cached data for a key.
    public func removeData(forKey key: String) async throws {
        cache.removeObject(forKey: key as NSString)
    }

    /// Removes all cached data.
    public func removeAll() async throws {
        cache.removeAllObjects()
    }
}
