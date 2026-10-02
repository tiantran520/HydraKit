import Foundation

/// A `NetworkClient` implementation backed by `URLSession`.
public final class HKURLSessionNetworkClient: NetworkClient {
    private let session: URLSession
    private let retryPolicy: RetryPolicy

    /// Creates a URL session network client.
    /// - Parameters:
    ///   - session: The URL session used to perform requests.
    ///   - retryPolicy: The retry policy used for failed attempts.
    public init(
        session: URLSession = URLSession(configuration: .ironBitDefault()),
        retryPolicy: RetryPolicy = .default
    ) {
        self.session = session
        self.retryPolicy = retryPolicy
    }

    /// Sends a URL request and returns raw response data.
    /// - Parameter request: The URL request to send.
    /// - Returns: A response containing raw data.
    public func data(for request: URLRequest) async throws -> Response<Data> {
        var attempt = 1

        while true {
            try Task.checkCancellation()

            do {
                return try await execute(request)
            } catch {
                if retryPolicy.shouldRetry(error, afterAttempt: attempt) {
                    let delay = retryPolicy.delay(afterAttempt: attempt)
                    attempt += 1
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    continue
                }

                throw error
            }
        }
    }

    /// Creates a cancellable request task for raw response data.
    /// - Parameter request: The URL request to send.
    /// - Returns: A cancellable request task.
    public func requestTask(for request: URLRequest) -> HKRequestTask<Data> {
        HKRequestTask {
            try await self.data(for: request)
        }
    }

    /// Creates a cancellable request task for a decoded response.
    /// - Parameters:
    ///   - request: The URL request to send.
    ///   - decoder: The decoder used to decode the response body.
    /// - Returns: A cancellable request task.
    public func requestTask<Value: Decodable>(
        for request: URLRequest,
        decoder: JSONDecoder = JSONDecoder()
    ) -> HKRequestTask<Value> {
        HKRequestTask {
            try await self.send(request, decoder: decoder)
        }
    }

    /// Creates a cancellable request task for an endpoint.
    /// - Parameters:
    ///   - endpoint: The endpoint to send.
    ///   - requestBuilder: The builder used to create the URL request.
    ///   - decoder: The decoder used to decode the response body.
    /// - Returns: A cancellable request task.
    public func requestTask<Value: Decodable>(
        for endpoint: any Endpoint,
        requestBuilder: any RequestBuilding = RequestBuilder(),
        decoder: JSONDecoder = JSONDecoder()
    ) -> HKRequestTask<Value> {
        HKRequestTask {
            try await self.send(endpoint, requestBuilder: requestBuilder, decoder: decoder)
        }
    }

    private func execute(_ request: URLRequest) async throws -> Response<Data> {
        do {
            let (data, urlResponse) = try await session.data(for: request)
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                throw HKNetworkError.invalidResponse
            }

            let status = HTTPStatus(rawValue: httpResponse.statusCode)
            let headers = HTTPHeaders(httpResponse.allHeaderFields.reduce(into: [:]) { result, entry in
                guard let key = entry.key as? String else { return }
                result[key] = "\(entry.value)"
            })

            guard status.isSuccess else {
                throw HKNetworkError.unacceptableStatus(status, data: data)
            }

            return Response(
                value: data,
                status: status,
                headers: headers,
                url: httpResponse.url
            )
        } catch is CancellationError {
            throw CancellationError()
        } catch let error as HKNetworkError {
            throw error
        } catch let error as URLError where error.code == .cancelled {
            throw CancellationError()
        } catch {
            throw HKNetworkError.transportFailed(error)
        }
    }
}
