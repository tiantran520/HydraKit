import Foundation

/// Handles deep links by routing to matching destinations.
@MainActor
public final class DeepLinkHandler {
    private let parser: any DeepLinkParser
    private let router: any Router
    private var routeFactory: @MainActor (DeepLink) -> AnyRoute?

    /// Creates a deep link handler.
    public init(
        parser: any DeepLinkParser = DefaultDeepLinkParser(),
        router: any Router,
        routeFactory: @escaping @MainActor (DeepLink) -> AnyRoute?
    ) {
        self.parser = parser
        self.router = router
        self.routeFactory = routeFactory
    }

    /// Handles a deep link URL.
    @discardableResult
    public func handle(_ url: URL) -> Bool {
        guard let deepLink = parser.parse(url), let route = routeFactory(deepLink) else {
            return false
        }
        router.push(route)
        return true
    }
}
