import SwiftUI

/// A small wrapper around localized string keys.
public struct LocalizedString: ExpressibleByStringLiteral {
    /// The localized key.
    public let key: LocalizedStringKey
    /// Fallback plain value.
    public let value: String

    /// Creates a localized string.
    public init(_ value: String) {
        self.value = value
        self.key = LocalizedStringKey(value)
    }

    /// Creates a localized string from a string literal.
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

public extension Text {
    /// Creates text from an IronBit localized string.
    init(_ localized: LocalizedString) {
        self.init(localized.key)
    }
}
