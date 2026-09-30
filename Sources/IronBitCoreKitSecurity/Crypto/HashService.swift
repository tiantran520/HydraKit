import Foundation
#if canImport(CryptoKit)
import CryptoKit
#endif

/// Creates cryptographic hashes.
public struct HashService: Sendable {
    /// Supported hash algorithms.
    public enum Algorithm: Sendable {
        /// SHA256 hash.
        case sha256
    }

    /// Creates a hash service.
    public init() {}

    /// Hashes data with an algorithm.
    public func hash(_ data: Data, algorithm: Algorithm = .sha256) -> Data {
        switch algorithm {
        case .sha256:
            #if canImport(CryptoKit)
            return Data(SHA256.hash(data: data))
            #else
            return data
            #endif
        }
    }
}
