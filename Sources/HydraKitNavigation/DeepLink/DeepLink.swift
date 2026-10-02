import Foundation

/// A parsed deep link request.
public struct DeepLink: Hashable, Sendable {
    /// The original URL.
    public let url: URL
    /// The route identifier resolved from the URL.
    public let routeIdentifier: RouteIdentifier
    /// Query parameters from the URL.
    public let parameters: [String: String]

    /// Creates a deep link.
    public init(url: URL, routeIdentifier: RouteIdentifier, parameters: [String: String] = [:]) {
        self.url = url
        self.routeIdentifier = routeIdentifier
        self.parameters = parameters
    }
}
