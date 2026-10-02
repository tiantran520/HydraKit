import Foundation

/// Handles ETag request and response headers for cached network requests.
public final class HKETagHandler: @unchecked Sendable {
    private let cache: any NetworkCache
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    /// Creates an ETag handler.
    /// - Parameter cache: The cache used to store ETags.
    public init(cache: any NetworkCache = HKMemoryCache()) {
        self.cache = cache
    }

    /// Adds an `If-None-Match` header to a request when an ETag is cached.
    /// - Parameters:
    ///   - request: The request to modify.
    ///   - key: The cache key associated with the request.
    /// - Returns: A request containing the cached ETag header when available.
    public func applyETag(to request: URLRequest, key: String) async throws -> URLRequest {
        guard let etag = try await eTag(forKey: key) else {
            return request
        }

        var request = request
        request.setValue(etag, forHTTPHeaderField: "If-None-Match")
        return request
    }

    /// Stores the response ETag when present.
    /// - Parameters:
    ///   - response: The response whose headers may contain an ETag.
    ///   - key: The cache key associated with the response.
    public func storeETag(from response: Response<Data>, key: String) async throws {
        guard let etag = response.headers["ETag"] else {
            return
        }

        let entry = ETagEntry(value: etag)
        let data = try encoder.encode(entry)
        try await cache.store(data, forKey: cacheKey(for: key))
    }

    /// Reads a cached ETag.
    /// - Parameter key: The cache key associated with the ETag.
    /// - Returns: A cached ETag when present.
    public func eTag(forKey key: String) async throws -> String? {
        guard let data = try await cache.data(forKey: cacheKey(for: key)) else {
            return nil
        }

        return try decoder.decode(ETagEntry.self, from: data).value
    }

    /// Removes a cached ETag.
    /// - Parameter key: The cache key associated with the ETag.
    public func removeETag(forKey key: String) async throws {
        try await cache.removeData(forKey: cacheKey(for: key))
    }

    private func cacheKey(for key: String) -> String {
        "etag:\(key)"
    }
}

private struct ETagEntry: Codable {
    let value: String
}
