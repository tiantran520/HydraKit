import Foundation

/// A type that describes an HTTP endpoint.
public protocol Endpoint {
    /// The base URL for the endpoint.
    var baseURL: URL { get }

    /// The path appended to the base URL.
    var path: String { get }

    /// The HTTP method used for the request.
    var method: HKHTTPMethod { get }

    /// The HTTP headers sent with the request.
    var headers: HTTPHeaders { get }

    /// Query items appended to the request URL.
    var queryItems: [URLQueryItem] { get }

    /// The HTTP body data.
    var body: Data? { get }

    /// The request timeout interval.
    var timeoutInterval: TimeInterval { get }

    /// The cache policy used by the request.
    var cachePolicy: URLRequest.CachePolicy { get }
}

public extension Endpoint {
    /// The default HTTP method.
    var method: HKHTTPMethod { .get }

    /// The default HTTP headers.
    var headers: HTTPHeaders { HTTPHeaders() }

    /// The default query items.
    var queryItems: [URLQueryItem] { [] }

    /// The default HTTP body.
    var body: Data? { nil }

    /// The default request timeout interval.
    var timeoutInterval: TimeInterval { 60 }

    /// The default cache policy.
    var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }
}
