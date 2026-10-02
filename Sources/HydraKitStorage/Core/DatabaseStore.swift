import Foundation

/// A storage abstraction for database-style persistence.
public protocol DatabaseStore: Sendable {
    /// The model type managed by the database store.
    associatedtype Model

    /// Inserts a model into the database.
    /// - Parameter model: The model to insert.
    func insert(_ model: Model) async throws

    /// Deletes a model from the database.
    /// - Parameter model: The model to delete.
    func delete(_ model: Model) async throws

    /// Saves pending changes.
    func save() async throws
}
