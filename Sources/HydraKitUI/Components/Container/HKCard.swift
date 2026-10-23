import SwiftUI

/// A noninteractive themed container. Content retains its own accessibility elements.
public struct HKCard<Content: View>: View {
    /// Plain surface, outlined surface, or a surface with the theme shadow.
    public enum HKVariant: Sendable { case plain, outlined, elevated }

    @Environment(\.ironBitTheme) private var theme
    private let variant: HKVariant
    private let padding: CGFloat?
    private let background: Color?
    private let cornerRadius: CGFloat?
    private let borderColor: Color?
    private let borderWidth: CGFloat?
    private let content: Content

    /// Defaults: plain, theme lg padding, surface background, md radius, standard border width.
    /// A border is shown for outlined cards or when an explicit borderColor is supplied.
    /// Preserves the original ViewBuilder initializer, including factory references.
    public init(variant: HKVariant = .plain, @ViewBuilder content: () -> Content) {
        self.init(variant: variant, padding: nil, content: content)
    }

    /// Creates a container with optional padding, background, radius, and border overrides.
    public init(
        variant: HKVariant = .plain,
        padding: CGFloat? = nil, background: Color? = nil,
        cornerRadius: CGFloat? = nil, borderColor: Color? = nil, borderWidth: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.variant = variant
        self.padding = padding
        self.background = background
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding ?? theme.spacing.lg)
            .background(background ?? theme.colors.surface)
            .clipShape(shape)
            .overlay {
                if variant == .outlined || borderColor != nil {
                    shape.strokeBorder(borderColor ?? theme.colors.border,
                                       lineWidth: borderWidth ?? theme.controls.borderWidth)
                }
            }
            .shadow(
                color: variant == .elevated ? theme.shadows.sm.color : .clear,
                radius: theme.shadows.sm.radius,
                x: theme.shadows.sm.x, y: theme.shadows.sm.y
            )
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius ?? theme.radius.md, style: .continuous)
    }
}

#Preview("Card variants and flexible content") {
    HKComponentPreview {
        HKCard { HKText("Plain card") }
        HKCard(variant: .outlined) { HKText("A long card description that wraps and grows with Dynamic Type.") }
        HKCard(variant: .elevated) {
            VStack(alignment: .leading) {
                HKText("Account", variant: .headline)
                HKButton("Manage", variant: .secondary) {}
            }
        }
    }
}
