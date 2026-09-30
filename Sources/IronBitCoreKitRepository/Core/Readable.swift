import Foundation

/// A repository capability for reading models.
public protocol Readable: Sendable {
    /// The identifier type.
    associatedtype ID: Hashable & Sendable

    /// The domain model type.
    associatedtype Model: Sendable

    /// Reads a model by identifier.
    /// - Parameter id: The model identifier.
    /// - Returns: The model when available.
    func read(id: ID) async throws -> Model?

    /// Reads all available models.
    /// - Returns: All models currently available.
    func readAll() async throws -> [Model]
}
