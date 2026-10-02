import Foundation

/// An example user entity.
public struct User: Entity, Codable {
    /// The unique user identifier.
    public let id: UUID

    /// The user's display name.
    public let name: String

    /// The user's email address.
    public let email: Email

    /// Creates a user entity.
    /// - Parameters:
    ///   - id: The unique user identifier.
    ///   - name: The user's display name.
    ///   - email: The user's email address.
    public init(id: UUID = UUID(), name: String, email: Email) {
        self.id = id
        self.name = name
        self.email = email
    }
}
