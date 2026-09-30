import Foundation
#if canImport(Security)
import Security
#endif

/// Generates secure random values.
public enum SecureRandom {
    /// Generates random data.
    public static func data(count: Int) -> Data {
        var bytes = [UInt8](repeating: 0, count: count)
        #if canImport(Security)
        let status = SecRandomCopyBytes(kSecRandomDefault, count, &bytes)
        if status != errSecSuccess {
            bytes = bytes.map { _ in UInt8.random(in: UInt8.min...UInt8.max) }
        }
        #else
        bytes = bytes.map { _ in UInt8.random(in: UInt8.min...UInt8.max) }
        #endif
        return Data(bytes)
    }

    /// Generates a URL-safe random string.
    public static func urlSafeString(length: Int) -> String {
        let alphabet = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        let bytes = [UInt8](data(count: length))
        return String(bytes.map { alphabet[Int($0) % alphabet.count] })
    }
}
