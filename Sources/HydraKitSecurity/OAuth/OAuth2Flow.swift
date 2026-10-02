import Foundation

/// Builds OAuth 2.0 authorization URLs.
public struct OAuth2Flow: Sendable {
    /// OAuth client identifier.
    public let clientID: String
    /// Authorization endpoint.
    public let authorizationURL: URL
    /// Redirect URI.
    public let redirectURI: URL
    /// Requested scopes.
    public let scopes: [String]

    /// Creates an OAuth flow builder.
    public init(clientID: String, authorizationURL: URL, redirectURI: URL, scopes: [String] = []) {
        self.clientID = clientID
        self.authorizationURL = authorizationURL
        self.redirectURI = redirectURI
        self.scopes = scopes
    }

    /// Creates an authorization URL with optional PKCE values.
    public func authorizationRequestURL(state: String, pkce: PKCE? = nil, additionalParameters: [String: String] = [:]) -> URL? {
        var components = URLComponents(url: authorizationURL, resolvingAgainstBaseURL: false)
        var items = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI.absoluteString),
            URLQueryItem(name: "state", value: state)
        ]
        if !scopes.isEmpty {
            items.append(URLQueryItem(name: "scope", value: scopes.joined(separator: " ")))
        }
        if let pkce {
            items.append(URLQueryItem(name: "code_challenge", value: pkce.codeChallenge))
            items.append(URLQueryItem(name: "code_challenge_method", value: pkce.method.rawValue))
        }
        items.append(contentsOf: additionalParameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        components?.queryItems = items
        return components?.url
    }
}
