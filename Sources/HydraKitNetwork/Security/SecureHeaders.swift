import Foundation

/// Factory methods for security-related HTTP headers.
public enum HKSecureHeaders {
    /// Creates a bearer authorization header.
    /// - Parameter token: The bearer token.
    /// - Returns: Headers containing `Authorization`.
    public static func bearerToken(_ token: String) -> HTTPHeaders {
        [HTTPHeaders.authorization: "Bearer \(token)"]
    }

    /// Creates a basic authorization header.
    /// - Parameters:
    ///   - username: The username.
    ///   - password: The password.
    /// - Returns: Headers containing `Authorization`.
    public static func basic(username: String, password: String) -> HTTPHeaders {
        let credentials = "\(username):\(password)"
        let encoded = Data(credentials.utf8).base64EncodedString()
        return [HTTPHeaders.authorization: "Basic \(encoded)"]
    }

    /// Creates common JSON security headers.
    /// - Returns: Headers for JSON APIs.
    public static func jsonAPI() -> HTTPHeaders {
        [
            HTTPHeaders.accept: HTTPHeaders.applicationJSON,
            HTTPHeaders.contentType: HTTPHeaders.applicationJSON,
            "X-Content-Type-Options": "nosniff"
        ]
    }

    /// Creates a header collection by combining multiple header sets.
    /// - Parameter headers: The header sets to combine.
    /// - Returns: A merged header collection.
    public static func merge(_ headers: HTTPHeaders...) -> HTTPHeaders {
        headers.reduce(into: HTTPHeaders()) { result, next in
            result.merge(next)
        }
    }
}
