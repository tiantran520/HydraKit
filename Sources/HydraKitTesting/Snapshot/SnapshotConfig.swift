import Foundation

/// Configuration for file-based snapshot assertions.
public struct SnapshotConfig: Equatable, Sendable {
    /// The directory where snapshots are stored.
    public let directory: URL

    /// Whether assertions should record snapshots instead of comparing.
    public let recordsSnapshots: Bool

    /// The default extension used for text snapshots.
    public let fileExtension: String

    /// Creates a snapshot configuration.
    /// - Parameters:
    ///   - directory: The directory where snapshots are stored.
    ///   - recordsSnapshots: Whether to record snapshots instead of comparing.
    ///   - fileExtension: The default extension used for text snapshots.
    public init(
        directory: URL,
        recordsSnapshots: Bool = false,
        fileExtension: String = "txt"
    ) {
        self.directory = directory
        self.recordsSnapshots = recordsSnapshots
        self.fileExtension = fileExtension
    }
}

public extension SnapshotConfig {
    /// A default snapshot configuration rooted at the current working directory.
    static var `default`: SnapshotConfig {
        SnapshotConfig(directory: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
    }
}
