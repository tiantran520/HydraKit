import Foundation

/// A repository capability for writing models.
public protocol Writable: Sendable {
    /// The identifier type.
    associatedtype ID: Hashable & Sendable

    /// The domain model type.
    associatedtype Model: Sendable

    /// Saves a model.
    /// - Parameter model: The model to save.
    func save(_ model: Model) async throws

    /// Deletes a model by identifier.
    /// - Parameter id: The model identifier.
    func delete(id: ID) async throws
}
