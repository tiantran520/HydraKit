import Foundation

/// Errors produced by domain logic.
public enum HKDomainError: Error, Equatable {
    /// An entity could not be found.
    case notFound(String)

    /// A domain rule was violated.
    case ruleViolation(String)

    /// A validation operation failed.
    case validation(HKValidationError)

    /// An unexpected domain failure occurred.
    case unexpected(String)
}

extension HKDomainError: LocalizedError {
    /// A localized domain error description.
    public var errorDescription: String? {
        switch self {
        case let .notFound(message):
            "Không tìm thấy: \(message)"
        case let .ruleViolation(message):
            "Vi phạm quy tắc domain: \(message)"
        case let .validation(error):
            error.localizedDescription
        case let .unexpected(message):
            "Lỗi domain không mong đợi: \(message)"
        }
    }
}
