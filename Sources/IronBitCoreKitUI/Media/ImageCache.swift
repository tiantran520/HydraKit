import Foundation

/// An in-memory cache for image data.
public final class ImageCache: @unchecked Sendable {
    /// Shared image cache instance.
    public static let shared = ImageCache()

    private let cache = NSCache<NSURL, NSData>()

    /// Creates an image cache.
    public init() {}

    /// Reads image data for a URL.
    public func data(for url: URL) -> Data? {
        cache.object(forKey: url as NSURL) as Data?
    }

    /// Stores image data for a URL.
    public func setData(_ data: Data, for url: URL) {
        cache.setObject(data as NSData, forKey: url as NSURL)
    }

    /// Clears cached image data.
    public func removeAll() {
        cache.removeAllObjects()
    }
}
