import SwiftUI

/// The default Hydra UI theme.
public struct DefaultTheme: Theme {
    /// Color tokens.
    public let colors: ColorTokens
    /// Typography tokens.
    public let typography: TypographyTokens
    /// Spacing tokens.
    public let spacing: SpacingTokens
    /// Radius tokens.
    public let radius: RadiusTokens
    /// Shadow tokens.
    public let shadows: ShadowTokens
    /// Animation tokens.
    public let animations: AnimationTokens

    /// Creates the default theme.
    public init(
        colors: ColorTokens = ColorTokens(),
        typography: TypographyTokens = TypographyTokens(),
        spacing: SpacingTokens = SpacingTokens(),
        radius: RadiusTokens = RadiusTokens(),
        shadows: ShadowTokens = ShadowTokens(),
        animations: AnimationTokens = AnimationTokens()
    ) {
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.radius = radius
        self.shadows = shadows
        self.animations = animations
    }
}
