import Foundation
import XCTest

/// A helper for simple file-based snapshot tests.
public enum SnapshotHelper {
    /// Asserts that a string matches a stored snapshot.
    /// - Parameters:
    ///   - value: The string to compare or record.
    ///   - name: The snapshot file name without extension.
    ///   - config: The snapshot configuration.
    ///   - file: The test file.
    ///   - line: The test line.
    public static func assertSnapshot(
        _ value: String,
        named name: String,
        config: SnapshotConfig = .default,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let url = config.directory
            .appendingPathComponent(name)
            .appendingPathExtension(config.fileExtension)

        do {
            try FileManager.default.createDirectory(
                at: config.directory,
                withIntermediateDirectories: true
            )

            if config.recordsSnapshots || !FileManager.default.fileExists(atPath: url.path) {
                try value.write(to: url, atomically: true, encoding: .utf8)
                return
            }

            let expected = try String(contentsOf: url, encoding: .utf8)
            XCTAssertEqual(value, expected, file: file, line: line)
        } catch {
            XCTFail("Snapshot assertion failed: \(error)", file: file, line: line)
        }
    }

    /// Asserts that data matches a stored snapshot.
    /// - Parameters:
    ///   - value: The data to compare or record.
    ///   - name: The snapshot file name.
    ///   - config: The snapshot configuration.
    ///   - file: The test file.
    ///   - line: The test line.
    public static func assertSnapshot(
        _ value: Data,
        named name: String,
        config: SnapshotConfig,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let url = config.directory.appendingPathComponent(name)

        do {
            try FileManager.default.createDirectory(
                at: config.directory,
                withIntermediateDirectories: true
            )

            if config.recordsSnapshots || !FileManager.default.fileExists(atPath: url.path) {
                try value.write(to: url, options: .atomic)
                return
            }

            let expected = try Data(contentsOf: url)
            XCTAssertEqual(value, expected, file: file, line: line)
        } catch {
            XCTFail("Snapshot assertion failed: \(error)", file: file, line: line)
        }
    }
}
