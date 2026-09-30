import Foundation
import IronBitCoreKitStorage

/// A repository backed by a key-value local store.
public final class LocalRepository<ID: Hashable & Sendable, Model: Codable & Sendable>: Repository, @unchecked Sendable {
    private let store: any KeyValueStore
    private let keyProvider: @Sendable (ID) -> StorageKey<Model>
    private let allKeysProvider: (@Sendable () -> [ID])?
    private let continuation: AsyncStream<[Model]>.Continuation
    private let modelStream: AsyncStream<[Model]>

    /// Creates a local repository.
    public init(
        store: any KeyValueStore,
        keyProvider: @escaping @Sendable (ID) -> StorageKey<Model>,
        allKeysProvider: (@Sendable () -> [ID])? = nil
    ) {
        self.store = store
        self.keyProvider = keyProvider
        self.allKeysProvider = allKeysProvider

        var capturedContinuation: AsyncStream<[Model]>.Continuation!
        self.modelStream = AsyncStream { continuation in
            capturedContinuation = continuation
        }
        self.continuation = capturedContinuation
    }

    /// Reads a model from local storage.
    public func read(id: ID) async throws -> Model? {
        try await store.value(for: keyProvider(id))
    }

    /// Reads all models from local storage when an all-keys provider is configured.
    public func readAll() async throws -> [Model] {
        guard let allKeysProvider else {
            return []
        }

        var models: [Model] = []
        for id in allKeysProvider() {
            if let model = try await read(id: id) {
                models.append(model)
            }
        }
        return models
    }

    /// Saves a model to local storage.
    public func save(_ model: Model) async throws {
        throw RepositoryError.unsupportedOperation("LocalRepository cần save(_:id:) để lưu model với ID rõ ràng.")
    }

    /// Saves a model to local storage with an identifier.
    public func save(_ model: Model, id: ID) async throws {
        try await store.setValue(model, for: keyProvider(id))
        continuation.yield(try await readAll())
    }

    /// Deletes a model from local storage.
    public func delete(id: ID) async throws {
        try await store.removeValue(for: keyProvider(id))
        continuation.yield(try await readAll())
    }

    /// Streams local snapshots.
    public func stream() -> AsyncStream<[Model]> {
        modelStream
    }
}
