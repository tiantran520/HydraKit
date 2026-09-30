import Foundation

/// A service facade for analytics tracking.
public protocol AnalyticsService: Sendable {
    /// Tracks an analytics event.
    func track(_ event: AnalyticsEvent) async
    /// Tracks a screen view.
    func trackScreen(_ screen: ScreenView) async
    /// Identifies the current user.
    func identify(userID: String?) async
}
