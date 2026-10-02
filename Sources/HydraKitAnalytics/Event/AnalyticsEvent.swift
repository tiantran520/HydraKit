import Foundation

/// A trackable analytics event.
public struct AnalyticsEvent: Codable, Hashable, Sendable {
    /// Event name.
    public let name: String
    /// Event properties.
    public let properties: EventProperties
    /// Event timestamp.
    public let timestamp: Date

    /// Creates an analytics event.
    public init(name: String, properties: EventProperties = EventProperties(), timestamp: Date = Date()) {
        self.name = name
        self.properties = properties
        self.timestamp = timestamp
    }
}
