import Foundation

/// Tracks screen view events.
public struct ScreenTracker: Sendable {
    private let analytics: any AnalyticsService

    /// Creates a screen tracker.
    public init(analytics: any AnalyticsService) {
        self.analytics = analytics
    }

    /// Tracks a screen by name.
    public func track(_ name: String, properties: EventProperties = EventProperties()) async {
        await analytics.trackScreen(ScreenView(name: name, properties: properties))
    }
}
