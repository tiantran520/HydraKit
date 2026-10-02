import Foundation

/// An HTTP response status code.
public struct HTTPStatus: RawRepresentable, Equatable, Hashable, Sendable {
    /// The raw status code.
    public let rawValue: Int

    /// Creates an HTTP status code.
    /// - Parameter rawValue: The numeric status code.
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// A Boolean value indicating whether the status code is in the `200..<300` range.
    public var isSuccess: Bool {
        (200..<300).contains(rawValue)
    }

    /// A Boolean value indicating whether the status code is in the `100..<200` range.
    public var isInformational: Bool {
        (100..<200).contains(rawValue)
    }

    /// A Boolean value indicating whether the status code is in the `300..<400` range.
    public var isRedirection: Bool {
        (300..<400).contains(rawValue)
    }

    /// A Boolean value indicating whether the status code is in the `400..<500` range.
    public var isClientError: Bool {
        (400..<500).contains(rawValue)
    }

    /// A Boolean value indicating whether the status code is in the `500..<600` range.
    public var isServerError: Bool {
        (500..<600).contains(rawValue)
    }
}

extension HTTPStatus: ExpressibleByIntegerLiteral {
    /// Creates an HTTP status from an integer literal.
    public init(integerLiteral value: Int) {
        self.init(rawValue: value)
    }
}

public extension HTTPStatus {
    /// `200 OK`.
    static let ok = HTTPStatus(rawValue: 200)

    /// `201 Created`.
    static let created = HTTPStatus(rawValue: 201)

    /// `204 No Content`.
    static let noContent = HTTPStatus(rawValue: 204)

    /// `400 Bad Request`.
    static let badRequest = HTTPStatus(rawValue: 400)

    /// `401 Unauthorized`.
    static let unauthorized = HTTPStatus(rawValue: 401)

    /// `403 Forbidden`.
    static let forbidden = HTTPStatus(rawValue: 403)

    /// `404 Not Found`.
    static let notFound = HTTPStatus(rawValue: 404)

    /// `500 Internal Server Error`.
    static let internalServerError = HTTPStatus(rawValue: 500)
}
