import Foundation

/// Convenience helpers for `Result`.
public extension Result {
    /// The success value, or `nil` when the result is a failure.
    var value: Success? {
        guard case let .success(value) = self else { return nil }
        return value
    }

    /// The failure value, or `nil` when the result is a success.
    var error: Failure? {
        guard case let .failure(error) = self else { return nil }
        return error
    }

    /// Converts the result into an optional success value.
    /// - Returns: The success value, or `nil`.
    func optional() -> Success? {
        try? get()
    }
}
