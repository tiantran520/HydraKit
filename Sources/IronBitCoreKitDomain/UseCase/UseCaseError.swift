import Foundation

/// Errors produced while executing use cases.
public enum UseCaseError: Error, Equatable {
    /// The use case received invalid input.
    case invalidInput(String)

    /// The use case failed because of a domain error.
    case domain(DomainError)

    /// The use case was cancelled.
    case cancelled

    /// The use case failed unexpectedly.
    case unexpected(String)
}

extension UseCaseError: LocalizedError {
    /// A localized use case error description.
    public var errorDescription: String? {
        switch self {
        case let .invalidInput(message):
            "Input không hợp lệ: \(message)"
        case let .domain(error):
            error.localizedDescription
        case .cancelled:
            "Use case đã bị hủy."
        case let .unexpected(message):
            "Use case thất bại: \(message)"
        }
    }
}
