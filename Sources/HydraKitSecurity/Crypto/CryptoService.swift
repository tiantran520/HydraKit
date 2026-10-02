import Foundation

/// A symmetric encryption service abstraction.
public protocol CryptoService: Sendable {
    /// Encrypts data.
    func encrypt(_ data: Data) throws -> Data
    /// Decrypts data.
    func decrypt(_ data: Data) throws -> Data
}
