import SwiftUI

public extension ColorScheme {
    /// Returns a default theme adjusted for the color scheme.
    var defaultHydraTheme: DefaultTheme {
        switch self {
        case .dark:
            DefaultTheme(
                colors: ColorTokens(
                    primary: .cyan,
                    secondary: .gray,
                    accent: .mint,
                    background: Color(red: 0.07, green: 0.08, blue: 0.09),
                    surface: Color(red: 0.12, green: 0.13, blue: 0.15),
                    textPrimary: .primary,
                    textSecondary: .secondary,
                    border: .gray.opacity(0.45)
                )
            )
        default:
            DefaultTheme()
        }
    }
}
