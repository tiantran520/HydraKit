import Foundation

/// Assigns users to experiment variants.
public struct VariantAssigner: Sendable {
    /// Creates a variant assigner.
    public init() {}

    /// Assigns a variant deterministically from a user identifier.
    public func assign(userID: String, experiment: Experiment) -> String? {
        guard !experiment.variants.isEmpty else { return nil }
        let index = abs(userID.hashValue ^ experiment.id.hashValue) % experiment.variants.count
        return experiment.variants[index]
    }
}
