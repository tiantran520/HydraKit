import Foundation

/// A keychain item descriptor.
public struct KeychainItem: Hashable, Sendable {
    /// The service namespace.
    public let service: String

    /// The account identifier.
    public let account: String

    /// The item accessibility.
    public let accessibility: KeychainAccessibility

    /// Creates a keychain item descriptor.
    public init(
        service: String,
        account: String,
        accessibility: KeychainAccessibility = .whenUnlocked
    ) {
        self.service = service
        self.account = account
        self.accessibility = accessibility
    }
}
