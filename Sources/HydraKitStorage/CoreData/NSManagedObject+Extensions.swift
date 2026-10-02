import CoreData
import Foundation

/// Convenience helpers for managed objects.
public extension NSManagedObject {
    /// The entity name for the managed object type.
    static var entityName: String {
        String(describing: self)
    }
}
