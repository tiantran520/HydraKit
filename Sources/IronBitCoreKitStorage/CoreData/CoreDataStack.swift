import CoreData
import Foundation

/// A Core Data stack backed by `NSPersistentContainer`.
public final class CoreDataStack: @unchecked Sendable {
    /// The persistent container.
    public let container: NSPersistentContainer

    /// The main view context.
    public var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    /// Creates a Core Data stack.
    public init(container: NSPersistentContainer) {
        self.container = container
    }

    /// Loads persistent stores.
    public func loadPersistentStores() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            container.loadPersistentStores { _, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    /// Creates a background context.
    public func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }
}
