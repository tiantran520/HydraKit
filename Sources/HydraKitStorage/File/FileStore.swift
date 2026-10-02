import Foundation

/// A file-system backed data store.
public final class HKFileStore: @unchecked Sendable {
    private let baseURL: URL
    private let fileManager: FileManager

    /// Creates a file store.
    public init(location: HKFileLocation = .documents, fileManager: FileManager = .default) {
        self.baseURL = location.url
        self.fileManager = fileManager
    }

    /// Reads data at a relative path.
    public func data(at path: String) throws -> Data {
        try Data(contentsOf: url(for: path))
    }

    /// Writes data at a relative path.
    public func write(_ data: Data, to path: String) throws {
        let url = url(for: path)
        try fileManager.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: url, options: .atomic)
    }

    /// Removes data at a relative path.
    public func remove(at path: String) throws {
        let url = url(for: path)
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
    }

    /// Resolves a relative path into an absolute URL.
    public func url(for path: String) -> URL {
        baseURL.appendingPathComponent(path, isDirectory: false)
    }
}
