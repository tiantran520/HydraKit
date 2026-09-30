import Foundation

/// A URL session delegate that validates server trust with certificate pinning.
public final class SSLPinningDelegate: NSObject, URLSessionDelegate {
    private let certificatePinning: CertificatePinning

    /// Creates an SSL pinning delegate.
    /// - Parameter certificatePinning: The certificate pinning validator.
    public init(certificatePinning: CertificatePinning) {
        self.certificatePinning = certificatePinning
    }

    /// Handles URL session authentication challenges.
    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        if certificatePinning.validate(serverTrust: serverTrust) {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
