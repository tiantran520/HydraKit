import Foundation

/// A strategy that coordinates local and network reads.
public protocol SyncStrategy: Sendable {
    /// The identifier type.
    associatedtype ID: Hashable & Sendable

    /// The model type.
    associatedtype Model: Sendable

    /// Reads a model using local and network closures.
    func read(
        id: ID,
        localRead: @Sendable (ID) async throws -> Model?,
        networkRead: @Sendable (ID) async throws -> Model?,
        localSave: @Sendable (Model, ID) async throws -> Void
    ) async throws -> Model?
}
