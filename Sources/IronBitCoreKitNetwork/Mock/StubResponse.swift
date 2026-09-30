import Foundation

/// A stubbed raw network response used by `MockNetworkClient`.
public struct StubResponse: Sendable {
    /// The response data.
    public let data: Data

    /// The HTTP status.
    public let status: HTTPStatus

    /// The response headers.
    public let headers: HTTPHeaders

    /// The response URL.
    public let url: URL?

    /// Creates a stub response.
    /// - Parameters:
    ///   - data: The response data.
    ///   - status: The HTTP status.
    ///   - headers: The response headers.
    ///   - url: The response URL.
    public init(
        data: Data = Data(),
        status: HTTPStatus = .ok,
        headers: HTTPHeaders = HTTPHeaders(),
        url: URL? = nil
    ) {
        self.data = data
        self.status = status
        self.headers = headers
        self.url = url
    }

    /// Creates a typed `Response<Data>`.
    /// - Returns: The typed response value.
    public func response() -> Response<Data> {
        Response(value: data, status: status, headers: headers, url: url)
    }
}

public extension StubResponse {
    /// Creates a JSON stub response from an encodable value.
    /// - Parameters:
    ///   - value: The value to encode.
    ///   - status: The HTTP status.
    ///   - encoder: The JSON encoder to use.
    /// - Returns: A stub response containing JSON data.
    static func json<Value: Encodable>(
        _ value: Value,
        status: HTTPStatus = .ok,
        encoder: JSONEncoder = JSONEncoder()
    ) throws -> StubResponse {
        StubResponse(
            data: try encoder.encode(value),
            status: status,
            headers: [HTTPHeaders.contentType: HTTPHeaders.applicationJSON]
        )
    }
}
