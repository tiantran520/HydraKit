import Foundation
import Security

/// Accessibility options for keychain items.
public enum KeychainAccessibility: Sendable {
    /// Available after the first device unlock.
    case afterFirstUnlock

    /// Available only when the device is unlocked.
    case whenUnlocked

    /// Available after the first unlock on this device only.
    case afterFirstUnlockThisDeviceOnly

    /// Available when unlocked on this device only.
    case whenUnlockedThisDeviceOnly

    /// The Security framework value.
    var secValue: CFString {
        switch self {
        case .afterFirstUnlock:
            kSecAttrAccessibleAfterFirstUnlock
        case .whenUnlocked:
            kSecAttrAccessibleWhenUnlocked
        case .afterFirstUnlockThisDeviceOnly:
            kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        case .whenUnlockedThisDeviceOnly:
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        }
    }
}
