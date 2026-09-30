import Foundation

/// A sync strategy that prefers network before local cache.
public struct NetworkFirstStrategy<ID: Hashable & Sendable, Model: Sendable>: SyncStrategy {
    /// Creates a network-first strategy.
    public init() {}

    /// Reads from network first and falls back to local cache when network fails.
    public func read(
        id: ID,
        localRead: @Sendable (ID) async throws -> Model?,
        networkRead: @Sendable (ID) async throws -> Model?,
        localSave: @Sendable (Model, ID) async throws -> Void
    ) async throws -> Model? {
        do {
            let remote = try await networkRead(id)
            if let remote {
                try await localSave(remote, id)
            }
            return remote
        } catch {
            return try await localRead(id)
        }
    }
}
