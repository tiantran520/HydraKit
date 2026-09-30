import SwiftUI

/// Shadow tokens used for elevated surfaces.
public struct ShadowTokens: Sendable {
    /// A single shadow preset.
    public struct Shadow: Sendable {
        /// Shadow color.
        public let color: Color
        /// Shadow radius.
        public let radius: CGFloat
        /// Horizontal offset.
        public let x: CGFloat
        /// Vertical offset.
        public let y: CGFloat

        /// Creates a shadow preset.
        public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
            self.color = color
            self.radius = radius
            self.x = x
            self.y = y
        }
    }

    /// Small elevation.
    public let sm: Shadow
    /// Medium elevation.
    public let md: Shadow
    /// Large elevation.
    public let lg: Shadow

    /// Creates shadow tokens.
    public init(
        sm: Shadow = Shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 1),
        md: Shadow = Shadow(color: .black.opacity(0.10), radius: 10, x: 0, y: 4),
        lg: Shadow = Shadow(color: .black.opacity(0.12), radius: 18, x: 0, y: 8)
    ) {
        self.sm = sm
        self.md = md
        self.lg = lg
    }
}
