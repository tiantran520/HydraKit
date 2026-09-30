import Foundation

/// Convenience helpers for common `String` operations.
public extension String {
    /// A Boolean value indicating whether the string contains only whitespace and newline characters.
    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Returns the string with leading and trailing whitespace and newline characters removed.
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Returns a localized string using the receiver as the localization key.
    /// - Parameters:
    ///   - tableName: The table to search. Pass `nil` to use `Localizable.strings`.
    ///   - bundle: The bundle containing localized resources.
    ///   - value: The fallback value.
    ///   - comment: A comment for translators.
    /// - Returns: A localized string.
    func localized(
        tableName: String? = nil,
        bundle: Bundle = .main,
        value: String = "",
        comment: String = ""
    ) -> String {
        NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: comment)
    }
}
