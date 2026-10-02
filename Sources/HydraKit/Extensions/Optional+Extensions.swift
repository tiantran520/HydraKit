import Foundation

/// Convenience helpers for optional values.
public extension Optional {
    /// Returns the wrapped value or throws the supplied error when the value is `nil`.
    /// - Parameter error: The error to throw when the optional is empty.
    /// - Returns: The wrapped value.
    func unwrap(orThrow error: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw error()
        }
        return value
    }

    /// Returns the wrapped value or the fallback value when the optional is empty.
    /// - Parameter fallback: The value to use when the optional is empty.
    /// - Returns: The wrapped value or fallback.
    func or(_ fallback: @autoclosure () -> Wrapped) -> Wrapped {
        self ?? fallback()
    }
}
