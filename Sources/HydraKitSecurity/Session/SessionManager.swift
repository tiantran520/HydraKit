import Foundation

/// Coordinates the current authentication session.
public actor SessionManager {
    private let store: any SessionStore
    private(set) var currentToken: AuthToken?

    /// Creates a session manager.
    public init(store: any SessionStore) {
        self.store = store
    }

    /// Loads the persisted session.
    public func restore() async throws -> AuthToken? {
        currentToken = try await store.load()
        return currentToken
    }

    /// Starts a session with a token.
    public func start(with token: AuthToken) async throws {
        currentToken = token
        try await store.save(token)
    }

    /// Ends the current session.
    public func end() async throws {
        currentToken = nil
        try await store.clear()
    }
}
