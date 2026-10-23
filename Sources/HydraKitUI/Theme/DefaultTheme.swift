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
    /// Shared interaction metrics.
    public let controls: ControlTokens

    /// Creates the default theme.
    /// Preserves the original constructor and typed factory references.
    public init(
        colors: ColorTokens = ColorTokens(),
        typography: TypographyTokens = TypographyTokens(),
        spacing: SpacingTokens = SpacingTokens(),
        radius: RadiusTokens = RadiusTokens(),
        shadows: ShadowTokens = ShadowTokens(),
        animations: AnimationTokens = AnimationTokens()
    ) {
        self.init(colors: colors, typography: typography, spacing: spacing, radius: radius,
                  shadows: shadows, animations: animations, controls: ControlTokens())
    }

    /// Creates a theme with optional design-token and interaction-metric overrides.
    public init(
        colors: ColorTokens = ColorTokens(),
        typography: TypographyTokens = TypographyTokens(),
        spacing: SpacingTokens = SpacingTokens(),
        radius: RadiusTokens = RadiusTokens(),
        shadows: ShadowTokens = ShadowTokens(),
        animations: AnimationTokens = AnimationTokens(),
        controls: ControlTokens = ControlTokens()
    ) {
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.radius = radius
        self.shadows = shadows
        self.animations = animations
        self.controls = controls
    }
}
