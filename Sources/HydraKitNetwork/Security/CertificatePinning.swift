import Foundation
import Security

/// A certificate pinning validator.
public struct CertificatePinning: Sendable {
    private let pinnedCertificates: Set<Data>
    private let pinnedPublicKeys: Set<Data>

    /// Creates a certificate pinning validator.
    /// - Parameters:
    ///   - pinnedCertificates: DER-encoded certificates that are trusted.
    ///   - pinnedPublicKeys: External representations of public keys that are trusted.
    public init(
        pinnedCertificates: Set<Data> = [],
        pinnedPublicKeys: Set<Data> = []
    ) {
        self.pinnedCertificates = pinnedCertificates
        self.pinnedPublicKeys = pinnedPublicKeys
    }

    /// Validates a server trust object against configured pins.
    /// - Parameter serverTrust: The server trust to validate.
    /// - Returns: `true` when the trust contains a pinned certificate or public key.
    public func validate(serverTrust: SecTrust) -> Bool {
        guard !pinnedCertificates.isEmpty || !pinnedPublicKeys.isEmpty else {
            return true
        }

        if containsPinnedCertificate(in: serverTrust) {
            return true
        }

        if containsPinnedPublicKey(in: serverTrust) {
            return true
        }

        return false
    }

    private func containsPinnedCertificate(in serverTrust: SecTrust) -> Bool {
        for certificate in certificates(in: serverTrust) {
            let data = SecCertificateCopyData(certificate) as Data
            if pinnedCertificates.contains(data) {
                return true
            }
        }

        return false
    }

    private func containsPinnedPublicKey(in serverTrust: SecTrust) -> Bool {
        for certificate in certificates(in: serverTrust) {
            guard let key = SecCertificateCopyKey(certificate),
                  let data = SecKeyCopyExternalRepresentation(key, nil) as Data? else {
                continue
            }

            if pinnedPublicKeys.contains(data) {
                return true
            }
        }

        return false
    }

    private func certificates(in serverTrust: SecTrust) -> [SecCertificate] {
        (SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate]) ?? []
    }
}
