import SwiftUI

/// A native button themed through `ironBitTheme`. The parent owns loading state.
public struct HKButton<Label: View>: View {
    /// Visual treatment of the button.
    public enum HKVariant: Sendable { case primary, secondary, tertiary }
    /// Minimum height and padding; labels may grow vertically at any size.
    public enum HKSize: Sendable { case sm, md, lg }

    @Environment(\.ironBitTheme) private var theme
    private let variant: HKVariant
    private let size: HKSize
    private let isLoading: Bool
    private let loadingLabel: Text
    private let action: @MainActor () -> Void
    private let label: Label

    /// Creates a button. Defaults: primary, medium, idle, full width.
    /// Loading preserves the label and disables activation, including keyboard activation.
    /// Preserves the original ViewBuilder initializer, including factory references.
    public init(
        variant: HKVariant = .primary,
        action: @escaping @MainActor () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.init(variant: variant, size: .md, action: action, label: label)
    }

    /// Creates a button with optional size, loading, and accessibility feedback.
    public init(
        variant: HKVariant = .primary,
        size: HKSize = .md,
        isLoading: Bool = false,
        loadingLabel: Text = Text("Loading"),
        action: @escaping @MainActor () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.variant = variant
        self.size = size
        self.isLoading = isLoading
        self.loadingLabel = loadingLabel
        self.action = action
        self.label = label()
    }

    public var body: some View {
        Button(action: performAction) {
            HStack(spacing: theme.spacing.sm) {
                if isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .tint(variant == .primary ? theme.colors.onPrimary : theme.colors.primary)
                        .accessibilityHidden(true)
                }
                label.fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
        }
        .buttonStyle(HKComponentButtonStyle<Label>(variant: variant, size: size))
        .disabled(isLoading)
        .hkOptionalAccessibilityValue(isLoading ? loadingLabel : nil)
    }

    @MainActor
    func performAction() {
        guard !isLoading else { return }
        action()
    }
}

public extension HKButton where Label == Text {
    /// Preserves the original title initializer, including factory references.
    init(_ title: String, variant: HKVariant = .primary, action: @escaping @MainActor () -> Void) {
        self.init(title, variant: variant, size: .md, action: action)
    }

    /// Creates a text button. For string catalog keys, use the ViewBuilder initializer with Text.
    init(
        _ title: String,
        variant: HKVariant = .primary,
        size: HKSize = .md,
        isLoading: Bool = false,
        loadingLabel: Text = Text("Loading"),
        action: @escaping @MainActor () -> Void
    ) {
        self.init(variant: variant, size: size, isLoading: isLoading, loadingLabel: loadingLabel, action: action) {
            Text(title)
        }
    }
}

public extension HKButton where Label == HKLabel {
    /// Creates a button with a decorative symbol before or after its title.
    init(
        _ title: String,
        systemImage: String,
        iconPlacement: HKIconPlacement = .leading,
        variant: HKVariant = .primary,
        size: HKSize = .md,
        isLoading: Bool = false,
        loadingLabel: Text = Text("Loading"),
        action: @escaping @MainActor () -> Void
    ) {
        self.init(variant: variant, size: size, isLoading: isLoading, loadingLabel: loadingLabel, action: action) {
            HKLabel(title, systemImage: systemImage, iconPlacement: iconPlacement, inheritsStyle: true)
        }
    }
}

/// Shared implementation used by HKButton and the primary native Button style.
struct HKComponentButtonStyle<Label: View>: ButtonStyle {
    let variant: HKButton<Label>.HKVariant
    let size: HKButton<Label>.HKSize

    func makeBody(configuration: Configuration) -> some View {
        HKButtonSurface<Configuration.Label, Label>(
            content: configuration.label, variant: variant, size: size, isPressed: configuration.isPressed
        )
    }
}

// Environment is resolved on a View, including when the style is forwarded by hkPrimary.
private struct HKButtonSurface<Content: View, Label: View>: View {
    @Environment(\.ironBitTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let content: Content
    let variant: HKButton<Label>.HKVariant
    let size: HKButton<Label>.HKSize
    let isPressed: Bool

    var body: some View {
        content
            .font(theme.typography.button)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, theme.spacing.sm)
            .frame(maxWidth: .infinity, minHeight: max(theme.controls.minimumTarget, minimumHeight))
            .foregroundStyle(variant == .primary ? theme.colors.onPrimary : theme.colors.primary)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous))
            .overlay {
                if variant == .secondary {
                    RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous)
                        .strokeBorder(theme.colors.primary, lineWidth: theme.controls.borderWidth)
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous))
            .opacity(!isEnabled ? theme.controls.disabledOpacity : (isPressed ? theme.controls.pressedOpacity : 1))
            .animation(reduceMotion ? nil : theme.animations.fast, value: isPressed)
    }

    private var horizontalPadding: CGFloat {
        switch size {
        case .sm: theme.spacing.md
        case .md: theme.spacing.lg
        case .lg: theme.spacing.xl
        }
    }

    private var minimumHeight: CGFloat {
        switch size {
        case .sm: theme.controls.smallHeight
        case .md: theme.controls.mediumHeight
        case .lg: theme.controls.largeHeight
        }
    }

    private var background: Color {
        switch variant {
        case .primary: theme.colors.primary
        case .secondary: theme.colors.surface
        case .tertiary: .clear
        }
    }
}

#Preview("Button variants and states") {
    HKComponentPreview {
        HKButton("Small", size: .sm) {}
        HKButton("Secondary", variant: .secondary) {}
        HKButton("Large tertiary", variant: .tertiary, size: .lg) {}
        HKButton("Continue", systemImage: "arrow.right", iconPlacement: .trailing) {}
        HKButton("Save", isLoading: true) {}
        HKButton("Disabled") {}.disabled(true)
        HKButton("A long localized action title that wraps onto multiple lines") {}
    }
}
