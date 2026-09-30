import Foundation

extension URL: ValueObject {}

public extension URL {
    /// Creates and validates a URL string.
    /// - Parameter string: The URL string.
    /// - Returns: A valid URL.
    static func valueObject(_ string: String) throws -> URL {
        guard let url = URL(string: string), url.scheme != nil else {
            throw ValidationError.invalidURL(string)
        }
        return url
    }
}
