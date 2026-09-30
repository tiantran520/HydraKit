import Foundation

/// An A/B experiment definition.
public struct Experiment: Codable, Hashable, Sendable {
    /// Experiment identifier.
    public let id: String
    /// Available variants.
    public let variants: [String]

    /// Creates an experiment.
    public init(id: String, variants: [String]) {
        self.id = id
        self.variants = variants
    }
}
