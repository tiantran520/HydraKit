import Foundation

/// A mock network client for tests and previews.
public final class HKMockNetworkClient: NetworkClient, @unchecked Sendable {
    private let lock = NSLock()
    private var queuedResults: [Result<StubResponse, Error>]
    private let delaySimulator: NetworkDelaySimulator

    /// Requests captured by the mock client.
    public private(set) var requests: [URLRequest] = []

    /// Creates a mock network client.
    /// - Parameters:
    ///   - results: The queued results returned by the client.
    ///   - delaySimulator: A delay simulator used before returning each result.
    public init(
        results: [Result<StubResponse, Error>] = [],
        delaySimulator: NetworkDelaySimulator = NetworkDelaySimulator()
    ) {
        self.queuedResults = results
        self.delaySimulator = delaySimulator
    }

    /// Adds a stub response to the queue.
    /// - Parameter response: The response to append.
    public func enqueue(_ response: StubResponse) {
        lock.withLock {
            queuedResults.append(.success(response))
        }
    }

    /// Adds an error to the queue.
    /// - Parameter error: The error to append.
    public func enqueue(_ error: Error) {
        lock.withLock {
            queuedResults.append(.failure(error))
        }
    }

    /// Sends a URL request and returns the next queued result.
    /// - Parameter request: The URL request to capture.
    /// - Returns: A response containing raw data.
    public func data(for request: URLRequest) async throws -> Response<Data> {
        try Task.checkCancellation()
        try await delaySimulator.wait()
        try Task.checkCancellation()

        let result = lock.withLock {
            requests.append(request)
            if queuedResults.isEmpty {
                return Result<StubResponse, Error>.failure(HKNetworkError.invalidResponse)
            }
            return queuedResults.removeFirst()
        }

        switch result {
        case let .success(response):
            if response.status.isSuccess {
                return response.response()
            } else {
                throw HKNetworkError.unacceptableStatus(response.status, data: response.data)
            }
        case let .failure(error):
            throw error
        }
    }

    /// Clears captured requests and queued responses.
    public func reset() {
        lock.withLock {
            requests.removeAll()
            queuedResults.removeAll()
        }
    }
}
