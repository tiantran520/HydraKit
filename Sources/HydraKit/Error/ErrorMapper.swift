import Foundation

/// Maps arbitrary errors into app-specific errors.
public struct ErrorMapper<Output: AppError>: Sendable {
    private let transform: @Sendable (Error) -> Output

    /// Creates an error mapper.
    /// - Parameter transform: A closure that converts any error into an app error.
    public init(transform: @escaping @Sendable (Error) -> Output) {
        self.transform = transform
    }

    /// Converts an error into the configured app error type.
    /// - Parameter error: The error to map.
    /// - Returns: The mapped app error.
    public func map(_ error: Error) -> Output {
        transform(error)
    }
}
