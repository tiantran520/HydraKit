import Foundation

/// Analytics event properties.
public struct EventProperties: Codable, Hashable, Sendable, ExpressibleByDictionaryLiteral {
    /// Raw property values.
    public let values: [String: String]

    /// Creates event properties.
    public init(_ values: [String: String] = [:]) {
        self.values = values
    }

    /// Creates event properties from a dictionary literal.
    public init(dictionaryLiteral elements: (String, String)...) {
        self.values = Dictionary(uniqueKeysWithValues: elements)
    }
}
