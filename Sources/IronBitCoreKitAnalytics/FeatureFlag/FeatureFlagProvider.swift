import Foundation

/// Provides feature flag values.
public protocol FeatureFlagProvider: Sendable {
    /// Returns whether a feature is enabled.
    func isEnabled(_ flag: FeatureFlag) async -> Bool
}
