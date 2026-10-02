import SwiftUI

private struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: any Theme = DefaultTheme()
}

public extension EnvironmentValues {
    /// The current Hydra theme.
    var ironBitTheme: any Theme {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

public extension View {
    /// Sets the Hydra theme for this view hierarchy.
    /// - Parameter theme: The theme to inject.
    /// - Returns: A view with the theme stored in the environment.
    func ironBitTheme(_ theme: any Theme) -> some View {
        environment(\.ironBitTheme, theme)
    }
}
