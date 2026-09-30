import Foundation

/// Common file storage locations.
public enum FileLocation: Sendable {
    /// The app documents directory.
    case documents

    /// The app caches directory.
    case caches

    /// A temporary directory.
    case temporary

    /// A custom directory URL.
    case custom(URL)

    /// Resolves the location into a directory URL.
    public var url: URL {
        switch self {
        case .documents:
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        case .caches:
            FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        case .temporary:
            FileManager.default.temporaryDirectory
        case let .custom(url):
            url
        }
    }
}
