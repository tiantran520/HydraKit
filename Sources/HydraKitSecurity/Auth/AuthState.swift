import Foundation

/// Authentication state for the current user.
public enum HKAuthState: Sendable {
    /// No authentication work has started.
    case unauthenticated
    /// Authentication is in progress.
    case authenticating
    /// The user is authenticated.
    case authenticated(AuthToken)
    /// Authentication failed.
    case failed(any Error)
}

public extension HKAuthState {
    /// Returns the token when authenticated.
    var token: AuthToken? {
        if case let .authenticated(token) = self {
            return token
        }
        return nil
    }
}
