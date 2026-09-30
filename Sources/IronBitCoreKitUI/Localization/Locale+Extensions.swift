import Foundation

public extension Locale {
    /// Returns whether the locale language is commonly displayed right-to-left.
    var isRightToLeftLanguage: Bool {
        guard let languageCode = language.languageCode?.identifier else { return false }
        return ["ar", "fa", "he", "ur"].contains(languageCode)
    }

    /// A readable language identifier.
    var ironBitLanguageIdentifier: String {
        language.languageCode?.identifier ?? identifier
    }
}
