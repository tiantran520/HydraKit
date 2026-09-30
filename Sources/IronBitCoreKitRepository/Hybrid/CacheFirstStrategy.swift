import Foundation

/// A sync strategy that prefers local cache before network.
public struct CacheFirstStrategy<ID: Hashable & Sendable, Model: Sendable>: SyncStrategy {
    /// Creates a cache-first strategy.
    public init() {}

    /// Reads from local first, then network, then stores the network result locally.
    public func read(
        id: ID,
        localRead: @Sendable (ID) async throws -> Model?,
        networkRead: @Sendable (ID) async throws -> Model?,
        localSave: @Sendable (Model, ID) async throws -> Void
    ) async throws -> Model? {
        if let cached = try await localRead(id) {
            return cached
        }

        let remote = try await networkRead(id)
        if let remote {
            try await localSave(remote, id)
        }
        return remote
    }
}
