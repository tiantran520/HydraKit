import SwiftUI

/// A compact selectable label.
public struct IBChip: View {
    /// Visual variants for chips.
    public enum HKVariant: Sendable {
        /// Filled chip.
        case filled
        /// Outlined chip.
        case outlined
        /// Soft tinted chip.
        case soft
    }

    @Environment(\.ironBitTheme) private var theme
    private let title: String
    private let variant: HKVariant
    private let isSelected: Bool

    /// Creates a chip.
    public init(_ title: String, variant: HKVariant = .soft, isSelected: Bool = false) {
        self.title = title
        self.variant = variant
        self.isSelected = isSelected
    }

    /// The chip body.
    public var body: some View {
        Text(title)
            .font(theme.typography.caption.weight(.semibold))
            .padding(.horizontal, theme.spacing.md)
            .padding(.vertical, theme.spacing.sm)
            .foregroundStyle(foreground)
            .background(background)
            .clipShape(Capsule())
            .overlay(border)
    }

    private var foreground: Color {
        variant == .filled || isSelected ? .white : theme.colors.primary
    }

    private var background: Color {
        switch variant {
        case .filled: theme.colors.primary
        case .outlined: .clear
        case .soft: isSelected ? theme.colors.primary : theme.colors.primary.opacity(0.12)
        }
    }

    @ViewBuilder
    private var border: some View {
        if variant == .outlined {
            Capsule().stroke(theme.colors.primary, lineWidth: 1)
        }
    }
}

#Preview {
    HStack {
        IBChip("Soft")
        IBChip("Filled", variant: .filled)
        IBChip("Outlined", variant: .outlined)
    }
    .padding()
}
