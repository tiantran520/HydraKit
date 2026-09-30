import Foundation

/// A policy that controls how cached network data is read and written.
public enum CachePolicy: Equatable, Sendable {
    /// Ignore cached data and fetch from the network.
    case reloadIgnoringCache

    /// Return cached data when available, otherwise fetch from the network.
    case returnCacheElseLoad

    /// Return cached data only.
    case returnCacheDontLoad

    /// Fetch from the network, then store the result in cache.
    case reloadAndStore
}
