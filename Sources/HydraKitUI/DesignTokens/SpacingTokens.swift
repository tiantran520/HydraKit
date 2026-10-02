import Foundation

/// Spacing scale used by IronBit UI components.
public struct SpacingTokens: Sendable {
    /// Extra small spacing.
    public let xs: CGFloat
    /// Small spacing.
    public let sm: CGFloat
    /// Medium spacing.
    public let md: CGFloat
    /// Large spacing.
    public let lg: CGFloat
    /// Extra large spacing.
    public let xl: CGFloat
    /// Double extra large spacing.
    public let xxl: CGFloat

    /// Creates spacing tokens.
    public init(xs: CGFloat = 4, sm: CGFloat = 8, md: CGFloat = 12, lg: CGFloat = 16, xl: CGFloat = 24, xxl: CGFloat = 32) {
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
    }
}
