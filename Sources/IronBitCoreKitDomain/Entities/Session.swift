import Foundation

/// An example authenticated session entity.
public struct Session: Entity, Codable {
    /// The unique session identifier.
    public let id: UUID

    /// The user associated with the session.
    public let userID: User.ID

    /// The access token for the session.
    public let accessToken: String

    /// The session creation date.
    public let createdAt: Date

    /// The optional expiration date.
    public let expiresAt: Date?

    /// Creates a session entity.
    public init(
        id: UUID = UUID(),
        userID: User.ID,
        accessToken: String,
        createdAt: Date = Date(),
        expiresAt: Date? = nil
    ) {
        self.id = id
        self.userID = userID
        self.accessToken = accessToken
        self.createdAt = createdAt
        self.expiresAt = expiresAt
    }

    /// A Boolean value indicating whether the session has expired.
    public var isExpired: Bool {
        expiresAt.map { $0 <= Date() } ?? false
    }
}
