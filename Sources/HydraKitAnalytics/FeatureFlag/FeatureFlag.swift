import Foundation

/// A feature flag definition.
public struct FeatureFlag: Codable, Hashable, Sendable {
    /// Flag key.
    public let key: String
    /// Default enabled state.
    public let defaultValue: Bool

    /// Creates a feature flag.
    public init(key: String, defaultValue: Bool = false) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
