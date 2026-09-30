import Foundation

/// A type that performs network requests.
public protocol NetworkClient {
    /// Sends a URL request and returns raw response data.
    /// - Parameter request: The URL request to send.
    /// - Returns: A response containing raw data.
    func data(for request: URLRequest) async throws -> Response<Data>
}

public extension NetworkClient {
    /// Sends an endpoint and decodes the response body.
    /// - Parameters:
    ///   - endpoint: The endpoint to send.
    ///   - requestBuilder: The builder used to create the URL request.
    ///   - decoder: The decoder used to decode the response body.
    /// - Returns: A response containing the decoded value.
    func send<Value: Decodable>(
        _ endpoint: any Endpoint,
        requestBuilder: any RequestBuilding = RequestBuilder(),
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> Response<Value> {
        let request = try requestBuilder.buildRequest(for: endpoint)
        return try await send(request, decoder: decoder)
    }

    /// Sends a URL request and decodes the response body.
    /// - Parameters:
    ///   - request: The URL request to send.
    ///   - decoder: The decoder used to decode the response body.
    /// - Returns: A response containing the decoded value.
    func send<Value: Decodable>(
        _ request: URLRequest,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> Response<Value> {
        let response = try await data(for: request)

        do {
            return try response.map {
                try decoder.decode(Value.self, from: $0)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
