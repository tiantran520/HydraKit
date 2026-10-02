import Foundation

/// A bearer-style authentication token.
public struct AuthToken: Codable, Hashable, Sendable {
    /// Access token value.
    public let accessToken: String
    /// Optional refresh token value.
    public let refreshToken: String?
    /// Token expiration date.
    public let expiresAt: Date?
    /// Token type, usually `Bearer`.
    public let tokenType: String

    /// Creates an authentication token.
    public init(accessToken: String, refreshToken: String? = nil, expiresAt: Date? = nil, tokenType: String = "Bearer") {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
        self.tokenType = tokenType
    }

    /// Returns whether the token is expired at a date.
    public func isExpired(at date: Date = Date()) -> Bool {
        guard let expiresAt else { return false }
        return expiresAt <= date
    }
}
