import SwiftUI

/// A themed card container.
public struct IBCard<Content: View>: View {
    /// Visual variants for cards.
    public enum Variant: Sendable {
        /// Plain surface.
        case plain
        /// Bordered surface.
        case outlined
        /// Elevated surface.
        case elevated
    }

    @Environment(\.ironBitTheme) private var theme
    private let variant: Variant
    private let content: Content

    /// Creates a card.
    public init(variant: Variant = .plain, @ViewBuilder content: () -> Content) {
        self.variant = variant
        self.content = content()
    }

    /// The card body.
    public var body: some View {
        content
            .padding(theme.spacing.lg)
            .background(theme.colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous))
            .overlay(outline)
            .shadow(
                color: variant == .elevated ? theme.shadows.sm.color : .clear,
                radius: theme.shadows.sm.radius,
                x: theme.shadows.sm.x,
                y: theme.shadows.sm.y
            )
    }

    @ViewBuilder
    private var outline: some View {
        if variant == .outlined {
            RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous)
                .stroke(theme.colors.border, lineWidth: 1)
        }
    }
}

#Preview {
    IBCard(variant: .elevated) {
        Text("IronBit card")
    }
    .padding()
}
