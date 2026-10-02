import Foundation

/// A provider that sends analytics events to a backend.
public protocol AnalyticsProvider: Sendable {
    /// Tracks an event.
    func track(_ event: AnalyticsEvent) async
    /// Sets a user identifier.
    func identify(userID: String?) async
    /// Sets common user properties.
    func setUserProperties(_ properties: EventProperties) async
}
