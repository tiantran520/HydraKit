import Foundation

/// A validated email address value object.
public struct Email: ValueObject, ExpressibleByStringLiteral {
    /// The raw email address.
    public let rawValue: String

    /// Creates and validates an email address.
    /// - Parameter rawValue: The raw email address.
    public init(_ rawValue: String) throws {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard Self.isValid(trimmed) else {
            throw HKValidationError.invalidEmail(rawValue)
        }
        self.rawValue = trimmed
    }

    /// Creates an email from a string literal.
    /// - Parameter value: The raw email address.
    public init(stringLiteral value: String) {
        self.rawValue = value
    }

    /// Returns whether a string is a valid email address.
    /// - Parameter value: The value to validate.
    public static func isValid(_ value: String) -> Bool {
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return value.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }
}
