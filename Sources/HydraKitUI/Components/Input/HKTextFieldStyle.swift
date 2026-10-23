import Foundation

/// Label layouts shared by HKTextField and HKSecureField.
public enum HKTextFieldStyle: Sendable {
    /// Original appearance: the title is used as the native placeholder.
    case standard
    /// Material-inspired outline: title floats onto the border on focus or when nonempty.
    case floating
    /// Persistent title above the input, with a filled surface and subtle elevation.
    case stacked
}

/// Presentation is derived from the parent text and native focus, never stored as duplicate state.
struct HKFieldPresentation {
    let style: HKTextFieldStyle
    let isFocused: Bool
    let hasText: Bool

    var isLabelFloating: Bool { style == .floating && (isFocused || hasText) }
}
