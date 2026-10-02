import Foundation

/// A repository that combines local and network repositories.
public final class HKHybridRepository<
    ID: Hashable & Sendable,
    Model: Codable & Sendable,
    Strategy: SyncStrategy
>: Repository, @unchecked Sendable where Strategy.ID == ID, Strategy.Model == Model {
    private let localRepository: HKLocalRepository<ID, Model>
    private let networkRead: @Sendable (ID) async throws -> Model?
    private let networkReadAll: @Sendable () async throws -> [Model]
    private let networkSave: @Sendable (Model) async throws -> Void
    private let networkDelete: @Sendable (ID) async throws -> Void
    private let idProvider: @Sendable (Model) -> ID
    private let strategy: Strategy

    /// Creates a hybrid repository.
    public init(
        localRepository: HKLocalRepository<ID, Model>,
        strategy: Strategy,
        idProvider: @escaping @Sendable (Model) -> ID,
        networkRead: @escaping @Sendable (ID) async throws -> Model?,
        networkReadAll: @escaping @Sendable () async throws -> [Model] = { [] },
        networkSave: @escaping @Sendable (Model) async throws -> Void = { _ in },
        networkDelete: @escaping @Sendable (ID) async throws -> Void = { _ in }
    ) {
        self.localRepository = localRepository
        self.strategy = strategy
        self.idProvider = idProvider
        self.networkRead = networkRead
        self.networkReadAll = networkReadAll
        self.networkSave = networkSave
        self.networkDelete = networkDelete
    }

    /// Reads a model using the configured sync strategy.
    public func read(id: ID) async throws -> Model? {
        try await strategy.read(
            id: id,
            localRead: { [localRepository] id in try await localRepository.read(id: id) },
            networkRead: networkRead,
            localSave: { [localRepository] model, id in try await localRepository.save(model, id: id) }
        )
    }

    /// Reads all models from network and refreshes local storage.
    public func readAll() async throws -> [Model] {
        let models = try await networkReadAll()
        for model in models {
            try await localRepository.save(model, id: idProvider(model))
        }
        return models
    }

    /// Saves a model to network and local storage.
    public func save(_ model: Model) async throws {
        try await networkSave(model)
        try await localRepository.save(model, id: idProvider(model))
    }

    /// Deletes a model from network and local storage.
    public func delete(id: ID) async throws {
        try await networkDelete(id)
        try await localRepository.delete(id: id)
    }

    /// Streams local snapshots.
    public func stream() -> AsyncStream<[Model]> {
        localRepository.stream()
    }
}
