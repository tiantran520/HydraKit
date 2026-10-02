import Foundation

/// Tracks events through one or more providers.
public actor EventTracker: AnalyticsService {
    private let providers: [any AnalyticsProvider]

    /// Creates an event tracker.
    public init(providers: [any AnalyticsProvider]) {
        self.providers = providers
    }

    /// Tracks an analytics event.
    public func track(_ event: AnalyticsEvent) async {
        await withTaskGroup(of: Void.self) { group in
            for provider in providers {
                group.addTask {
                    await provider.track(event)
                }
            }
        }
    }

    /// Tracks a screen view.
    public func trackScreen(_ screen: ScreenView) async {
        await track(AnalyticsEvent(name: "screen_view", properties: screen.properties))
    }

    /// Identifies the current user.
    public func identify(userID: String?) async {
        await withTaskGroup(of: Void.self) { group in
            for provider in providers {
                group.addTask {
                    await provider.identify(userID: userID)
                }
            }
        }
    }
}
