import Foundation
import CryptoKit

/// A disk-backed network cache.
public final class HKDiskCache: NetworkCache, @unchecked Sendable {
    private let directoryURL: URL
    private let fileManager: FileManager
    private let queue = DispatchQueue(label: "HKHydraKitNetwork.HKDiskCache")

    /// Creates a disk cache.
    /// - Parameters:
    ///   - directoryURL: The directory where cached files are stored.
    ///   - fileManager: The file manager used for disk operations.
    public init(
        directoryURL: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("HKHydraKitNetwork", isDirectory: true),
        fileManager: FileManager = .default
    ) {
        self.directoryURL = directoryURL
        self.fileManager = fileManager
    }

    /// Reads cached data for a key.
    public func data(forKey key: String) async throws -> Data? {
        try await perform { [self] in
            let url = self.cacheURL(forKey: key)
            guard self.fileManager.fileExists(atPath: url.path) else {
                return nil
            }
            return try Data(contentsOf: url)
        }
    }

    /// Stores data for a key.
    public func store(_ data: Data, forKey key: String) async throws {
        try await perform { [self] in
            try self.fileManager.createDirectory(
                at: self.directoryURL,
                withIntermediateDirectories: true
            )
            try data.write(to: self.cacheURL(forKey: key), options: .atomic)
        }
    }

    /// Removes cached data for a key.
    public func removeData(forKey key: String) async throws {
        try await perform { [self] in
            let url = self.cacheURL(forKey: key)
            if self.fileManager.fileExists(atPath: url.path) {
                try self.fileManager.removeItem(at: url)
            }
        }
    }

    /// Removes all cached data.
    public func removeAll() async throws {
        try await perform { [self] in
            if self.fileManager.fileExists(atPath: self.directoryURL.path) {
                try self.fileManager.removeItem(at: self.directoryURL)
            }
        }
    }

    private func cacheURL(forKey key: String) -> URL {
        directoryURL.appendingPathComponent(Self.fileName(forKey: key), isDirectory: false)
    }

    private static func fileName(forKey key: String) -> String {
        let digest = SHA256.hash(data: Data(key.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    private func perform<T>(_ work: @escaping () throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            queue.async {
                do {
                    continuation.resume(returning: try work())
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
