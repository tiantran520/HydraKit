import Foundation

/// Parses URLs into deep links.
public protocol DeepLinkParser: Sendable {
    /// Parses a URL into a deep link.
    func parse(_ url: URL) -> DeepLink?
}

/// A default URL parser that maps the path to a route identifier.
public struct DefaultDeepLinkParser: DeepLinkParser {
    /// Creates a parser.
    public init() {}

    /// Parses a URL into a deep link.
    public func parse(_ url: URL) -> DeepLink? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        let path = components.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let identifier = RouteIdentifier(path.isEmpty ? (components.host ?? "") : path)
        let parameters = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).compactMap { item in
            item.value.map { (item.name, $0) }
        })

        return DeepLink(url: url, routeIdentifier: identifier, parameters: parameters)
    }
}
