import Foundation

/// The severity of a log message.
public enum LogLevel: String, CaseIterable, Sendable {
    /// Verbose diagnostic information.
    case trace
    /// Debug-only information.
    case debug
    /// General runtime information.
    case info
    /// A recoverable warning.
    case warning
    /// A non-fatal error.
    case error
    /// A critical failure.
    case critical
}
