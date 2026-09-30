import Foundation

public extension URL {
    /// Returns query parameters as a dictionary.
    var deepLinkParameters: [String: String] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return [:]
        }
        return Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).compactMap { item in
            item.value.map { (item.name, $0) }
        })
    }

    /// Returns the path-based route identifier.
    var deepLinkRouteIdentifier: RouteIdentifier {
        let path = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return RouteIdentifier(path.isEmpty ? (host ?? "") : path)
    }
}
