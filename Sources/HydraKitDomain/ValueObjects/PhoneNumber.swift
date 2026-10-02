import Foundation

/// A validated phone number value object.
public struct PhoneNumber: ValueObject, ExpressibleByStringLiteral {
    /// The raw phone number.
    public let rawValue: String

    /// Creates and validates a phone number.
    /// - Parameter rawValue: The raw phone number.
    public init(_ rawValue: String) throws {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard Self.isValid(trimmed) else {
            throw HKValidationError.invalidPhoneNumber(rawValue)
        }
        self.rawValue = trimmed
    }

    /// Creates a phone number from a string literal.
    /// - Parameter value: The raw phone number.
    public init(stringLiteral value: String) {
        self.rawValue = value
    }

    /// Returns whether a string is a valid phone number.
    /// - Parameter value: The value to validate.
    public static func isValid(_ value: String) -> Bool {
        let pattern = #"^\+?[0-9\s().-]{7,20}$"#
        return value.range(of: pattern, options: .regularExpression) != nil
    }
}
