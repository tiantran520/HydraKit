import Foundation

/// A type that builds URL requests from endpoints.
public protocol RequestBuilding {
    /// Builds a URL request for an endpoint.
    /// - Parameter endpoint: The endpoint to build.
    /// - Returns: A configured URL request.
    func buildRequest(for endpoint: any Endpoint) throws -> URLRequest
}

/// The default endpoint request builder.
public struct RequestBuilder: RequestBuilding, Sendable {
    /// Creates a request builder.
    public init() {}

    /// Builds a URL request for an endpoint.
    /// - Parameter endpoint: The endpoint to build.
    /// - Returns: A configured URL request.
    public func buildRequest(for endpoint: any Endpoint) throws -> URLRequest {
        let url = try buildURL(for: endpoint)
        var request = URLRequest(
            url: url,
            cachePolicy: endpoint.cachePolicy,
            timeoutInterval: endpoint.timeoutInterval
        )

        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        endpoint.headers.forEach { name, value in
            request.setValue(value, forHTTPHeaderField: name)
        }

        return request
    }

    private func buildURL(for endpoint: any Endpoint) throws -> URL {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL(url.absoluteString)
        }

        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }

        guard let finalURL = components.url else {
            throw NetworkError.invalidURL(url.absoluteString)
        }

        return finalURL
    }
}
