import SwiftUI

/// Lightweight helpers for choosing accessible foreground colors.
public enum ContrastHelper {
    /// Returns black or white depending on the active color scheme.
    public static func readableForeground(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? .white : .black
    }

    /// Returns a semantic border color for contrast-sensitive surfaces.
    public static func borderColor(for colorScheme: ColorScheme, theme: any Theme = DefaultTheme()) -> Color {
        colorScheme == .dark ? theme.colors.border.opacity(0.75) : theme.colors.border
    }
}
