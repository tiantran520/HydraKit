import Foundation
import HTTPTypes
import OpenAPIRuntime
import HydraKitNetwork

/// Configuration errors reported by the OpenAPI transport before sending.
public enum HKOpenAPITransportError: Error, Equatable, Sendable {
    /// A request buffering limit must be zero or greater.
    case invalidMaximumRequestBodyBytes(Int)
}

/// Adapts generated OpenAPI requests to HydraKit's existing networking layer.
///
/// Bodies are buffered because `NetworkClient` operates on `Data`. The supplied
/// client must support concurrent calls: the legacy protocol does not require
/// `Sendable`, so this adapter cannot enforce that requirement at compile time.
public struct HKOpenAPIClientTransport: ClientTransport, @unchecked Sendable {
    private let networkClient: any NetworkClient
    private let maximumRequestBodyBytes: Int

    /// Creates a transport without adding implicit interceptor or cache wiring.
    /// - Parameters:
    ///   - networkClient: A client safe to use from concurrent tasks.
    ///   - maximumRequestBodyBytes: Request buffering limit; defaults to 16 MiB.
    ///     Negative values are rejected by `send` with `HKOpenAPITransportError`.
    public init(
        networkClient: any NetworkClient,
        maximumRequestBodyBytes: Int = 16 * 1024 * 1024
    ) {
        self.networkClient = networkClient
        self.maximumRequestBodyBytes = maximumRequestBodyBytes
    }

    /// Sends a request, recovering non-2xx status/body for generated output decoding.
    /// Other network errors propagate and are wrapped by generated operations in
    /// `ClientError.underlyingError`. Recovered status errors carry no headers
    /// because the legacy `unacceptableStatus` error does not retain them.
    public func send(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String
    ) async throws -> (HTTPResponse, HTTPBody?) {
        try Task.checkCancellation()
        guard maximumRequestBodyBytes >= 0 else {
            throw HKOpenAPITransportError.invalidMaximumRequestBodyBytes(maximumRequestBodyBytes)
        }
        // OpenAPI operation paths are appended to the server path, even when
        // they start with '/'. Keep percent escapes and query items intact.
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true),
              let scheme = components.scheme, ["http", "https"].contains(scheme.lowercased()),
              components.host != nil,
              let path = request.path, path.hasPrefix("/"),
              // Supply a fixed origin solely for parsing: a leading '//' in an
              // operation path must remain a path, not become an authority.
              let operationURL = URLComponents(string: "https://openapi.invalid" + path) else {
            throw HKNetworkError.invalidURL(baseURL.absoluteString + (request.path ?? ""))
        }
        let prefix = components.percentEncodedPath
        components.percentEncodedPath = (prefix.hasSuffix("/") ? String(prefix.dropLast()) : prefix)
            + operationURL.percentEncodedPath
        components.percentEncodedQuery = operationURL.percentEncodedQuery
        components.fragment = nil
        guard let url = components.url else {
            throw HKNetworkError.invalidURL(baseURL.absoluteString + path)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        for field in request.headerFields {
            urlRequest.addValue(field.value, forHTTPHeaderField: field.name.rawName)
        }
        if let body {
            urlRequest.httpBody = try await Data(collecting: body, upTo: maximumRequestBodyBytes)
        }
        try Task.checkCancellation()
        let response: Response<Data>
        do {
            response = try await networkClient.data(for: urlRequest)
        } catch HKNetworkError.unacceptableStatus(let status, let data) {
            return (HTTPResponse(status: .init(code: status.rawValue)), HTTPBody(data))
        }
        var fields = HTTPFields()
        for (key, value) in response.headers {
            if let name = HTTPField.Name(key) {
                fields.append(HTTPField(name: name, value: value))
            }
        }
        return (
            HTTPResponse(status: .init(code: response.status.rawValue), headerFields: fields),
            HTTPBody(response.value)
        )
    }
}
