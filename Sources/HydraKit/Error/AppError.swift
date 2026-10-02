import Foundation

/// A user-presentable application error.
public protocol AppError: LocalizedError, Sendable {
    /// A stable error code suitable for analytics or support.
    var code: String { get }

    /// A short title suitable for user interfaces.
    var title: String { get }

    /// A detailed message suitable for user interfaces.
    var message: String { get }

    /// The underlying error, when one exists.
    var underlyingError: Error? { get }
}

public extension AppError {
    /// The localized error description.
    var errorDescription: String? {
        message
    }

    /// The localized failure reason.
    var failureReason: String? {
        title
    }
}
