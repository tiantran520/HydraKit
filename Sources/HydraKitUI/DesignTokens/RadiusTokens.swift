import Foundation

/// Corner radius scale used by IronBit UI components.
public struct RadiusTokens: Sendable {
    /// Small radius.
    public let sm: CGFloat
    /// Medium radius.
    public let md: CGFloat
    /// Large radius.
    public let lg: CGFloat
    /// Pill radius.
    public let pill: CGFloat

    /// Creates radius tokens.
    public init(sm: CGFloat = 4, md: CGFloat = 8, lg: CGFloat = 12, pill: CGFloat = 999) {
        self.sm = sm
        self.md = md
        self.lg = lg
        self.pill = pill
    }
}
