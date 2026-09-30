import Foundation

/// Errors produced by storage components.
public enum StorageError: Error, Equatable {
    /// The requested value was not found.
    case notFound(String)

    /// The stored data could not be encoded.
    case encodingFailed(String)

    /// The stored data could not be decoded.
    case decodingFailed(String)

    /// The storage operation failed.
    case operationFailed(String)

    /// The requested key is invalid.
    case invalidKey(String)
}

extension StorageError: LocalizedError {
    /// A localized description for the storage error.
    public var errorDescription: String? {
        switch self {
        case let .notFound(key):
            "Không tìm thấy dữ liệu cho key: \(key)"
        case let .encodingFailed(message):
            "Không thể mã hóa dữ liệu: \(message)"
        case let .decodingFailed(message):
            "Không thể giải mã dữ liệu: \(message)"
        case let .operationFailed(message):
            "Thao tác lưu trữ thất bại: \(message)"
        case let .invalidKey(key):
            "Key không hợp lệ: \(key)"
        }
    }
}
