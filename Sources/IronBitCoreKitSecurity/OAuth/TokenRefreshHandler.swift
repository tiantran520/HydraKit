import Foundation

/// Refreshes tokens before they expire.
public actor TokenRefreshHandler {
    private let refresh: @Sendable (AuthToken) async throws -> AuthToken

    /// Creates a refresh handler.
    public init(refresh: @escaping @Sendable (AuthToken) async throws -> AuthToken) {
        self.refresh = refresh
    }

    /// Returns a valid token, refreshing when needed.
    public func validToken(from token: AuthToken, leeway: TimeInterval = 60) async throws -> AuthToken {
        guard let expiresAt = token.expiresAt else { return token }
        if expiresAt.timeIntervalSinceNow > leeway {
            return token
        }
        return try await refresh(token)
    }
}
