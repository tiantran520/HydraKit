import Foundation

/// A domain value defined entirely by its data.
public protocol ValueObject: Hashable, Codable, Sendable {}
