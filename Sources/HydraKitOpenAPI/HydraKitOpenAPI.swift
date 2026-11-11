import Foundation
import OpenAPIRuntime
import HydraKitNetwork

/// Version information for the OpenAPI module.
public enum HKHydraKitOpenAPI {
    /// Compatibility alias for `HydraKitOpenAPI.version`.
    public static let version = HydraKitOpenAPI.version
}

/// Creates the generated client with HydraKit transport and optional auth wiring.
public enum HydraKitOpenAPI {
    /// The module version, independent of legacy module constants.
    public static let version = "1.1.0"

    /// Creates a client for the contract bundled in this module.
    /// - Parameters:
    ///   - serverURL: Server URL including an optional API path prefix.
    ///   - networkClient: A concurrency-safe network client; preserves its retry policy.
    ///   - tokenProvider: Optional token provider shared with app authentication.
    /// - Returns: The generated client exposing the contract's operations.
    public static func makeClient(
        serverURL: URL,
        networkClient: any NetworkClient = HKURLSessionNetworkClient(),
        tokenProvider: (@Sendable () async throws -> String?)? = nil
    ) -> Client {
        var middlewares: [any ClientMiddleware] = []
        if let tokenProvider {
            middlewares.append(HKOpenAPIAuthMiddleware(tokenProvider: tokenProvider))
        }
        return Client(
            serverURL: serverURL,
            transport: HKOpenAPIClientTransport(networkClient: networkClient),
            middlewares: middlewares
        )
    }
}
