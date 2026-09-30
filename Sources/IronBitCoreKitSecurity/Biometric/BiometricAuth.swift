import Foundation
#if canImport(LocalAuthentication)
import LocalAuthentication
#endif

/// Performs biometric authentication when supported.
public struct BiometricAuth: Sendable {
    /// Creates a biometric authenticator.
    public init() {}

    /// Returns the supported biometric type.
    public func biometricType() -> BiometricType {
        #if canImport(LocalAuthentication)
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .touchID: return .touchID
        case .faceID: return .faceID
        #if os(visionOS)
        case .opticID: return .opticID
        #endif
        default: return .none
        }
        #else
        return .none
        #endif
    }

    /// Authenticates the user with biometrics.
    public func authenticate(reason: String) async throws -> Bool {
        #if canImport(LocalAuthentication)
        let context = LAContext()
        return try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
        #else
        return false
        #endif
    }
}
