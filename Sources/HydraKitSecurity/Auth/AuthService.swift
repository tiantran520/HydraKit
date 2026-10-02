import Foundation

/// A service that performs authentication operations.
public protocol AuthService: Sendable {
    /// Signs in and returns an authentication token.
    func signIn(username: String, password: String) async throws -> AuthToken
    /// Signs out the current user.
    func signOut() async throws
    /// Refreshes an authentication token.
    func refresh(_ token: AuthToken) async throws -> AuthToken
}
