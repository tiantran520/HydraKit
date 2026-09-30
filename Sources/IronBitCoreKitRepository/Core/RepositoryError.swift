import Foundation

/// Errors produced by repository operations.
public enum RepositoryError: Error, Equatable {
    /// The requested item was not found.
    case notFound(String)

    /// Mapping between DTO and domain model failed.
    case mappingFailed(String)

    /// The remote data source failed.
    case networkFailed(String)

    /// The local data source failed.
    case localFailed(String)

    /// The repository is missing a required capability.
    case unsupportedOperation(String)
}

extension RepositoryError: LocalizedError {
    /// A localized repository error description.
    public var errorDescription: String? {
        switch self {
        case let .notFound(message):
            "Không tìm thấy dữ liệu: \(message)"
        case let .mappingFailed(message):
            "Mapping dữ liệu thất bại: \(message)"
        case let .networkFailed(message):
            "Nguồn dữ liệu network thất bại: \(message)"
        case let .localFailed(message):
            "Nguồn dữ liệu local thất bại: \(message)"
        case let .unsupportedOperation(message):
            "Repository chưa hỗ trợ thao tác: \(message)"
        }
    }
}
