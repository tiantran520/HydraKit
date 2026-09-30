import Foundation

/// Logs non-fatal errors to a crash reporter.
public struct NonFatalErrorLogger: Sendable {
    private let reporter: any CrashReporter

    /// Creates a non-fatal error logger.
    public init(reporter: any CrashReporter) {
        self.reporter = reporter
    }

    /// Logs a non-fatal error.
    public func log(_ error: any Error, properties: EventProperties = EventProperties()) async {
        await reporter.record(error: error, properties: properties)
    }
}
