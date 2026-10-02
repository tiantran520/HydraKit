import Foundation
import os

/// A logger implementation backed by Apple's unified logging system.
public struct OSLogLogger: Logger {
    private let subsystem: String

    /// Creates an OS log logger.
    /// - Parameter subsystem: The subsystem used when creating `os.Logger` instances.
    public init(subsystem: String = Bundle.main.bundleIdentifier ?? "HKHydraKit") {
        self.subsystem = subsystem
    }

    /// Records a log message using the unified logging system.
    public func log(
        _ level: HKLogLevel,
        category: LogCategory,
        _ message: @autoclosure @escaping @Sendable () -> String,
        metadata: [String: String] = [:],
        file: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let logger = os.Logger(subsystem: subsystem, category: category.rawValue)
        let renderedMetadata = metadata.isEmpty ? "" : " \(metadata)"
        let renderedMessage = "\(message())\(renderedMetadata) [\(file):\(line) \(function)]"

        switch level {
        case .trace, .debug:
            logger.debug("\(renderedMessage, privacy: .public)")
        case .info:
            logger.info("\(renderedMessage, privacy: .public)")
        case .warning:
            logger.warning("\(renderedMessage, privacy: .public)")
        case .error:
            logger.error("\(renderedMessage, privacy: .public)")
        case .critical:
            logger.critical("\(renderedMessage, privacy: .public)")
        }
    }
}
