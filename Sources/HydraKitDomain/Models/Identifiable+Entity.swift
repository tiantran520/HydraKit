import Foundation

public extension Entity {
    /// Compares two entities by their stable identifier.
    /// - Parameters:
    ///   - lhs: The left entity.
    ///   - rhs: The right entity.
    /// - Returns: `true` when both entities have the same identifier.
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    /// Hashes the entity by its stable identifier.
    /// - Parameter hasher: The hasher to update.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
