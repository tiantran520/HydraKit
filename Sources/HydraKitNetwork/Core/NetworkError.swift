import Foundation

/// Errors produced by the networking layer.
public enum HKNetworkError: Error {
    /// The endpoint produced an invalid URL.
    case invalidURL(String)

    /// The URL loading system returned a non-HTTP response.
    case invalidResponse

    /// The server returned a non-success HTTP status.
    case unacceptableStatus(HTTPStatus, data: Data)

    /// Decoding the response body failed.
    case decodingFailed(Error)

    /// URL loading failed.
    case transportFailed(Error)
}

extension HKNetworkError: LocalizedError {
    /// A localized description for the error.
    public var errorDescription: String? {
        switch self {
        case let .invalidURL(url):
            "Invalid URL: \(url)"
        case .invalidResponse:
            "The server returned an invalid response."
        case let .unacceptableStatus(status, _):
            "The server returned an unacceptable status code: \(status.rawValue)."
        case let .decodingFailed(error):
            "Failed to decode response: \(error.localizedDescription)"
        case let .transportFailed(error):
            "Network transport failed: \(error.localizedDescription)"
        }
    }
}
