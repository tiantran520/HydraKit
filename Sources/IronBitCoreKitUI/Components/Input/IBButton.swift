import SwiftUI

/// A themed button with primary, secondary and tertiary variants.
public struct IBButton<Label: View>: View {
    /// Visual variants for ``IBButton``.
    public enum Variant: Sendable {
        /// Filled brand button.
        case primary
        /// Outlined button.
        case secondary
        /// Text-only button.
        case tertiary
    }

    @Environment(\.ironBitTheme) private var theme
    private let variant: Variant
    private let action: @MainActor () -> Void
    private let label: Label

    /// Creates a themed button.
    public init(
        variant: Variant = .primary,
        action: @escaping @MainActor () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.variant = variant
        self.action = action
        self.label = label()
    }

    /// The button body.
    public var body: some View {
        Button(action: action) {
            label
                .font(theme.typography.button)
                .frame(minHeight: 44)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, theme.spacing.lg)
        .foregroundStyle(foregroundColor)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous))
        .overlay(border)
        .animation(theme.animations.fast, value: variant)
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary: .white
        case .secondary, .tertiary: theme.colors.primary
        }
    }

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .primary: theme.colors.primary
        case .secondary: theme.colors.surface
        case .tertiary: Color.clear
        }
    }

    @ViewBuilder
    private var border: some View {
        if variant == .secondary {
            RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous)
                .stroke(theme.colors.primary, lineWidth: 1)
        }
    }
}

public extension IBButton where Label == Text {
    /// Creates a text-only themed button.
    init(_ title: String, variant: Variant = .primary, action: @escaping @MainActor () -> Void) {
        self.init(variant: variant, action: action) {
            Text(title)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        IBButton("Primary", variant: .primary) {}
        IBButton("Secondary", variant: .secondary) {}
        IBButton("Tertiary", variant: .tertiary) {}
    }
    .padding()
}
