import Foundation

/// A typed network response.
public struct Response<Value> {
    /// The decoded or raw response value.
    public let value: Value

    /// The HTTP status.
    public let status: HTTPStatus

    /// The response headers.
    public let headers: HTTPHeaders

    /// The original request URL.
    public let url: URL?

    /// Creates a network response.
    /// - Parameters:
    ///   - value: The decoded or raw response value.
    ///   - status: The HTTP status.
    ///   - headers: The response headers.
    ///   - url: The original request URL.
    public init(
        value: Value,
        status: HTTPStatus,
        headers: HTTPHeaders,
        url: URL?
    ) {
        self.value = value
        self.status = status
        self.headers = headers
        self.url = url
    }
}

public extension Response {
    /// Maps the response value while preserving response metadata.
    /// - Parameter transform: A closure that transforms the response value.
    /// - Returns: A response with the transformed value.
    func map<NewValue>(_ transform: (Value) throws -> NewValue) rethrows -> Response<NewValue> {
        Response<NewValue>(
            value: try transform(value),
            status: status,
            headers: headers,
            url: url
        )
    }
}
