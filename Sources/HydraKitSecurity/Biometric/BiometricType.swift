import Foundation

/// Supported biometric authentication types.
public enum HKBiometricType: Sendable {
    /// No biometric capability is available.
    case none
    /// Touch ID.
    case touchID
    /// Face ID.
    case faceID
    /// Optic ID.
    case opticID
}
