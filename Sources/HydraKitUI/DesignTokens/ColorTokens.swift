import SwiftUI

/// Design color tokens used by the default Hydra theme.
public struct ColorTokens: Sendable {
    /// Brand primary color.
    public let primary: Color
    /// Foreground on a filled primary surface; customize with the brand color.
    public let onPrimary: Color
    /// Brand secondary color.
    public let secondary: Color
    /// Accent color for lightweight emphasis.
    public let accent: Color
    /// Main page background color.
    public let background: Color
    /// Elevated surface color.
    public let surface: Color
    /// Primary text color.
    public let textPrimary: Color
    /// Secondary text color.
    public let textSecondary: Color
    /// Border and divider color.
    public let border: Color
    /// Success semantic color.
    public let success: Color
    /// Warning semantic color.
    public let warning: Color
    /// Error semantic color.
    public let error: Color

    /// Creates a set of color tokens.
    /// Preserves the original constructor and typed factory references.
    public init(
        primary: Color = .blue,
        secondary: Color = .gray,
        accent: Color = .teal,
        background: Color = Color(red: 0.98, green: 0.98, blue: 0.99),
        surface: Color = .white,
        textPrimary: Color = .primary,
        textSecondary: Color = .secondary,
        border: Color = .gray.opacity(0.28),
        success: Color = .green,
        warning: Color = .orange,
        error: Color = .red
    ) {
        self.init(primary: primary, secondary: secondary, accent: accent, background: background,
                  surface: surface, textPrimary: textPrimary, textSecondary: textSecondary,
                  border: border, success: success, warning: warning, error: error, onPrimary: .white)
    }

    /// Creates semantic colors, including an explicit foreground for primary surfaces.
    public init(
        primary: Color = .blue,
        secondary: Color = .gray,
        accent: Color = .teal,
        background: Color = Color(red: 0.98, green: 0.98, blue: 0.99),
        surface: Color = .white,
        textPrimary: Color = .primary,
        textSecondary: Color = .secondary,
        border: Color = .gray.opacity(0.28),
        success: Color = .green,
        warning: Color = .orange,
        error: Color = .red,
        onPrimary: Color = .white
    ) {
        self.primary = primary
        self.onPrimary = onPrimary
        self.secondary = secondary
        self.accent = accent
        self.background = background
        self.surface = surface
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.border = border
        self.success = success
        self.warning = warning
        self.error = error
    }
}
