import Foundation

/// A generic API error response model.
public struct ErrorResponse: Decodable, Equatable {
    /// A stable error code.
    public let code: String?

    /// A user-facing or developer-facing error message.
    public let message: String?

    /// Additional error details returned by the server.
    public let details: [String: AnyCodable]?

    /// Creates an error response.
    /// - Parameters:
    ///   - code: A stable error code.
    ///   - message: A user-facing or developer-facing error message.
    ///   - details: Additional error details returned by the server.
    public init(
        code: String? = nil,
        message: String? = nil,
        details: [String: AnyCodable]? = nil
    ) {
        self.code = code
        self.message = message
        self.details = details
    }
}
