import Foundation

/// A policy that decides when failed requests should be retried.
public struct RetryPolicy: Sendable {
    /// The maximum number of attempts, including the initial attempt.
    public let maxAttempts: Int

    /// The base delay used for exponential backoff.
    public let baseDelay: TimeInterval

    /// The maximum delay between retry attempts.
    public let maxDelay: TimeInterval

    /// The multiplier applied to the previous delay.
    public let multiplier: Double

    /// The HTTP status codes that should be retried.
    public let retryableStatusCodes: Set<Int>

    /// The URL loading errors that should be retried.
    public let retryableURLErrorCodes: Set<URLError.Code>

    /// Creates a retry policy.
    /// - Parameters:
    ///   - maxAttempts: The maximum number of attempts, including the initial attempt.
    ///   - baseDelay: The base delay used for exponential backoff.
    ///   - maxDelay: The maximum delay between retry attempts.
    ///   - multiplier: The multiplier applied to the previous delay.
    ///   - retryableStatusCodes: The HTTP status codes that should be retried.
    ///   - retryableURLErrorCodes: The URL loading errors that should be retried.
    public init(
        maxAttempts: Int = 3,
        baseDelay: TimeInterval = 0.3,
        maxDelay: TimeInterval = 5,
        multiplier: Double = 2,
        retryableStatusCodes: Set<Int> = Set(500...599),
        retryableURLErrorCodes: Set<URLError.Code> = [
            .cannotFindHost,
            .cannotConnectToHost,
            .dnsLookupFailed,
            .networkConnectionLost,
            .notConnectedToInternet,
            .timedOut
        ]
    ) {
        self.maxAttempts = max(1, maxAttempts)
        self.baseDelay = max(0, baseDelay)
        self.maxDelay = max(0, maxDelay)
        self.multiplier = max(1, multiplier)
        self.retryableStatusCodes = retryableStatusCodes
        self.retryableURLErrorCodes = retryableURLErrorCodes
    }

    /// Returns the delay before the next retry attempt.
    /// - Parameter attempt: The one-based attempt number that just failed.
    /// - Returns: The delay in seconds.
    public func delay(afterAttempt attempt: Int) -> TimeInterval {
        let exponent = max(0, attempt - 1)
        let delay = baseDelay * pow(multiplier, Double(exponent))
        return min(delay, maxDelay)
    }

    /// Returns whether an error should be retried after an attempt.
    /// - Parameters:
    ///   - error: The error produced by the attempt.
    ///   - attempt: The one-based attempt number that just failed.
    /// - Returns: `true` when another attempt should be made.
    public func shouldRetry(_ error: Error, afterAttempt attempt: Int) -> Bool {
        guard attempt < maxAttempts, !Task.isCancelled else {
            return false
        }

        if error is CancellationError {
            return false
        }

        if let networkError = error as? NetworkError {
            return shouldRetry(networkError)
        }

        if let urlError = error as? URLError {
            return retryableURLErrorCodes.contains(urlError.code)
        }

        return false
    }

    private func shouldRetry(_ error: NetworkError) -> Bool {
        switch error {
        case let .unacceptableStatus(status, _):
            retryableStatusCodes.contains(status.rawValue)
        case let .transportFailed(error):
            (error as? URLError).map { retryableURLErrorCodes.contains($0.code) } ?? false
        case .invalidURL, .invalidResponse, .decodingFailed:
            false
        }
    }
}

public extension RetryPolicy {
    /// A policy that disables retries.
    static let never = RetryPolicy(maxAttempts: 1, baseDelay: 0, maxDelay: 0)

    /// A default retry policy using exponential backoff.
    static let `default` = RetryPolicy()
}
