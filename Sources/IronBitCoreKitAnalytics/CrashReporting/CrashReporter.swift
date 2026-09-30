import Foundation

/// A crash reporting abstraction.
public protocol CrashReporter: Sendable {
    /// Records a non-fatal error.
    func record(error: any Error, properties: EventProperties) async
    /// Sets a user identifier.
    func setUserID(_ userID: String?) async
}
