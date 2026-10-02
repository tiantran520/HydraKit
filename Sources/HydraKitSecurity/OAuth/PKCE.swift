import Foundation
#if canImport(CryptoKit)
import CryptoKit
#endif

/// Proof Key for Code Exchange values.
public struct PKCE: Sendable {
    /// PKCE challenge methods.
    public enum HKMethod: String, Sendable {
        /// SHA256-based challenge.
        case s256 = "S256"
        /// Plain verifier challenge.
        case plain
    }

    /// Code verifier.
    public let codeVerifier: String
    /// Code challenge.
    public let codeChallenge: String
    /// Challenge method.
    public let method: HKMethod

    /// Creates PKCE values.
    public init(codeVerifier: String = HKSecureRandom.urlSafeString(length: 64), method: HKMethod = .s256) {
        self.codeVerifier = codeVerifier
        self.method = method
        self.codeChallenge = Self.challenge(for: codeVerifier, method: method)
    }

    private static func challenge(for verifier: String, method: HKMethod) -> String {
        guard method == .s256 else { return verifier }
        #if canImport(CryptoKit)
        let digest = SHA256.hash(data: Data(verifier.utf8))
        return Data(digest).base64URLEncodedString()
        #else
        return verifier
        #endif
    }
}

private extension Data {
    func base64URLEncodedString() -> String {
        base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
