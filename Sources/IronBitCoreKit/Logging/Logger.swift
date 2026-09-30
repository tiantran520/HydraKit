import Foundation

/// A type that records diagnostic messages.
public protocol Logger: Sendable {
    /// Records a log message.
    /// - Parameters:
    ///   - level: The severity of the message.
    ///   - category: The logical category for the message.
    ///   - message: The message to record.
    ///   - metadata: Additional diagnostic metadata.
    ///   - file: The source file that emitted the message.
    ///   - function: The source function that emitted the message.
    ///   - line: The source line that emitted the message.
    func log(
        _ level: LogLevel,
        category: LogCategory,
        _ message: @autoclosure @escaping @Sendable () -> String,
        metadata: [String: String],
        file: StaticString,
        function: StaticString,
        line: UInt
    )
}

public extension Logger {
    /// Records a trace message.
    func trace(_ message: @autoclosure @escaping @Sendable () -> String, category: LogCategory = .general) {
        log(.trace, category: category, message(), metadata: [:], file: #fileID, function: #function, line: #line)
    }

    /// Records a debug message.
    func debug(_ message: @autoclosure @escaping @Sendable () -> String, category: LogCategory = .general) {
        log(.debug, category: category, message(), metadata: [:], file: #fileID, function: #function, line: #line)
    }

    /// Records an informational message.
    func info(_ message: @autoclosure @escaping @Sendable () -> String, category: LogCategory = .general) {
        log(.info, category: category, message(), metadata: [:], file: #fileID, function: #function, line: #line)
    }

    /// Records a warning message.
    func warning(_ message: @autoclosure @escaping @Sendable () -> String, category: LogCategory = .general) {
        log(.warning, category: category, message(), metadata: [:], file: #fileID, function: #function, line: #line)
    }

    /// Records an error message.
    func error(_ message: @autoclosure @escaping @Sendable () -> String, category: LogCategory = .general) {
        log(.error, category: category, message(), metadata: [:], file: #fileID, function: #function, line: #line)
    }
}
