import SwiftUI

/// A reusable card styling modifier.
public struct CardStyle: ViewModifier {
    /// Card style variants.
    public enum HKVariant: Sendable {
        /// Plain surface.
        case plain
        /// Bordered surface.
        case outlined
        /// Elevated surface.
        case elevated
    }

    @Environment(\.ironBitTheme) private var theme
    private let variant: HKVariant

    /// Creates a card style modifier.
    public init(_ variant: HKVariant = .plain) {
        self.variant = variant
    }

    /// Applies the card style.
    public func body(content: Content) -> some View {
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

public extension View {
    /// Applies IronBit card styling.
    func ibCardStyle(_ variant: CardStyle.HKVariant = .plain) -> some View {
        modifier(CardStyle(variant))
    }
}
