import Foundation

/// A screen view analytics payload.
public struct ScreenView: Codable, Hashable, Sendable {
    /// Screen name.
    public let name: String
    /// Additional screen properties.
    public let properties: EventProperties

    /// Creates a screen view.
    public init(name: String, properties: EventProperties = EventProperties()) {
        self.name = name
        self.properties = EventProperties(properties.values.merging(["screen_name": name]) { current, _ in current })
    }
}
