import Foundation

/// A display model describing an error for presentation.
public struct ErrorPresentation: Equatable, Sendable {
    /// The presentation title.
    public let title: String

    /// The presentation message.
    public let message: String

    /// The stable error code.
    public let code: String?

    /// Creates an error presentation.
    public init(title: String, message: String, code: String? = nil) {
        self.title = title
        self.message = message
        self.code = code
    }
}

/// Converts errors into presentation models.
public struct ErrorPresenter: Sendable {
    /// Creates an error presenter.
    public init() {}

    /// Creates a presentation model for an error.
    /// - Parameter error: The error to present.
    /// - Returns: A user-facing error presentation.
    public func presentation(for error: Error) -> ErrorPresentation {
        if let appError = error as? any AppError {
            return ErrorPresentation(title: appError.title, message: appError.message, code: appError.code)
        }

        return ErrorPresentation(
            title: "Error",
            message: error.localizedDescription,
            code: nil
        )
    }
}
