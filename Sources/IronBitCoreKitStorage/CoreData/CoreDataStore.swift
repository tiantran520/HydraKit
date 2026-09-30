import CoreData
import Foundation

/// A Core Data backed database store.
public final class CoreDataStore<Model: NSManagedObject>: DatabaseStore, @unchecked Sendable {
    private let context: NSManagedObjectContext

    /// Creates a Core Data store.
    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    /// Inserts a managed object into the context.
    public func insert(_ model: Model) async throws {
        await context.perform {
            self.context.insert(model)
        }
    }

    /// Deletes a managed object from the context.
    public func delete(_ model: Model) async throws {
        await context.perform {
            self.context.delete(model)
        }
    }

    /// Saves pending changes.
    public func save() async throws {
        try await context.perform {
            if self.context.hasChanges {
                try self.context.save()
            }
        }
    }
}
