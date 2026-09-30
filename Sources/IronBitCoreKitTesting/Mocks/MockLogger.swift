import Foundation
import IronBitCoreKit

/// A logger test double that records every emitted log entry.
public final class MockLogger: Logger, @unchecked Sendable {
    /// A captured log message.
    public struct Entry: Equatable, Sendable {
        /// The log severity.
        public let level: LogLevel

        /// The log category.
        public let category: LogCategory

        /// The rendered message.
        public let message: String

        /// Additional metadata passed to the logger.
        public let metadata: [String: String]

        /// The source file that emitted the log.
        public let file: String

        /// The source function that emitted the log.
        public let function: String

        /// The source line that emitted the log.
        public let line: UInt
    }

    private let lock = NSLock()
    private var storage: [Entry] = []

    /// Creates an empty mock logger.
    public init() {}

    /// The entries recorded so far.
    public var entries: [Entry] {
        lock.withLock { storage }
    }

    /// Records a log entry for later inspection.
    public func log(
        _ level: LogLevel,
        category: LogCategory,
        _ message: @autoclosure @escaping @Sendable () -> String,
        metadata: [String: String],
        file: StaticString,
        function: StaticString,
        line: UInt
    ) {
        let entry = Entry(
            level: level,
            category: category,
            message: message(),
            metadata: metadata,
            file: "\(file)",
            function: "\(function)",
            line: line
        )

        lock.withLock {
            storage.append(entry)
        }
    }

    /// Removes all recorded entries.
    public func reset() {
        lock.withLock {
            storage.removeAll()
        }
    }
}
