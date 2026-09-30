import Foundation

#if canImport(SwiftData)
import SwiftData

/// A SwiftData backed database store.
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, visionOS 1, *)
public final class SwiftDataStore<Model: PersistentModel>: DatabaseStore, @unchecked Sendable {
    private let context: ModelContext

    /// Creates a SwiftData store.
    public init(context: ModelContext) {
        self.context = context
    }

    /// Inserts a persistent model.
    public func insert(_ model: Model) async throws {
        context.insert(model)
    }

    /// Deletes a persistent model.
    public func delete(_ model: Model) async throws {
        context.delete(model)
    }

    /// Saves pending changes.
    public func save() async throws {
        try context.save()
    }
}
#endif
