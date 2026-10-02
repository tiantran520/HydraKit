import Foundation

/// An in-memory repository for tests and previews.
public final class HKMockRepository<ID: Hashable & Sendable, Model: Sendable>: Repository, @unchecked Sendable {
    private var storage: [ID: Model]
    private let idProvider: @Sendable (Model) -> ID
    private let lock = NSLock()
    private let continuation: AsyncStream<[Model]>.Continuation
    private let modelStream: AsyncStream<[Model]>

    /// Creates a mock repository.
    public init(
        values: [Model] = [],
        idProvider: @escaping @Sendable (Model) -> ID
    ) {
        self.idProvider = idProvider
        self.storage = Dictionary(uniqueKeysWithValues: values.map { (idProvider($0), $0) })

        var capturedContinuation: AsyncStream<[Model]>.Continuation!
        self.modelStream = AsyncStream { continuation in
            capturedContinuation = continuation
        }
        self.continuation = capturedContinuation
    }

    /// Reads a model by identifier.
    public func read(id: ID) async throws -> Model? {
        lock.withLock {
            storage[id]
        }
    }

    /// Reads all models.
    public func readAll() async throws -> [Model] {
        lock.withLock {
            Array(storage.values)
        }
    }

    /// Saves a model.
    public func save(_ model: Model) async throws {
        lock.withLock {
            storage[idProvider(model)] = model
        }
        continuation.yield(try await readAll())
    }

    /// Deletes a model by identifier.
    public func delete(id: ID) async throws {
        _ = lock.withLock {
            storage.removeValue(forKey: id)
        }
        continuation.yield(try await readAll())
    }

    /// Streams model snapshots.
    public func stream() -> AsyncStream<[Model]> {
        modelStream
    }
}
