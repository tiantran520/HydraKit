import Foundation

/// Stores the current session token.
public protocol SessionStore: Sendable {
    /// Saves a token.
    func save(_ token: AuthToken?) async throws
    /// Loads the saved token.
    func load() async throws -> AuthToken?
    /// Clears the saved token.
    func clear() async throws
}
