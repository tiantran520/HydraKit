import SwiftUI

/// A theme that provides design tokens for IronBit UI components.
public protocol Theme: Sendable {
    /// Color tokens.
    var colors: ColorTokens { get }
    /// Typography tokens.
    var typography: TypographyTokens { get }
    /// Spacing tokens.
    var spacing: SpacingTokens { get }
    /// Radius tokens.
    var radius: RadiusTokens { get }
    /// Shadow tokens.
    var shadows: ShadowTokens { get }
    /// Animation tokens.
    var animations: AnimationTokens { get }
}
