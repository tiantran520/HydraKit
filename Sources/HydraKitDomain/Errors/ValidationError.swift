import Foundation

/// Errors produced by value validation.
public enum HKValidationError: Error, Equatable {
    /// The email address is invalid.
    case invalidEmail(String)

    /// The phone number is invalid.
    case invalidPhoneNumber(String)

    /// The URL is invalid.
    case invalidURL(String)

    /// A required value is empty.
    case emptyValue(String)

    /// A custom validation failure.
    case custom(String)
}

extension HKValidationError: LocalizedError {
    /// A localized validation error description.
    public var errorDescription: String? {
        switch self {
        case let .invalidEmail(value):
            "Email không hợp lệ: \(value)"
        case let .invalidPhoneNumber(value):
            "Số điện thoại không hợp lệ: \(value)"
        case let .invalidURL(value):
            "URL không hợp lệ: \(value)"
        case let .emptyValue(name):
            "Giá trị bắt buộc đang trống: \(name)"
        case let .custom(message):
            message
        }
    }
}
