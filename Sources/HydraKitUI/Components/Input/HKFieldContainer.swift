import SwiftUI

/// One appearance implementation for native text and secure controls.
struct HKFieldContainer<Content: View>: View {
    @Environment(\.ironBitTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let title: Text
    let style: HKTextFieldStyle
    let state: HKTextField.State
    let isFocused: Bool
    let hasText: Bool
    @ViewBuilder var content: () -> Content

    private var presentation: HKFieldPresentation {
        HKFieldPresentation(style: style, isFocused: isFocused, hasText: hasText)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            if style == .stacked {
                title.font(theme.typography.callout.weight(.semibold))
                    .foregroundStyle(isEnabled ? theme.colors.primary : theme.colors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityHidden(true)
            }
            if style == .floating {
                // Reserve room for the notch at every state, including long localized titles.
                title.font(theme.typography.caption)
                    .padding(.horizontal, theme.spacing.lg)
                    .hidden().accessibilityHidden(true)
            }
            field
            if let message = state.errorMessage {
                Label { Text(message).fixedSize(horizontal: false, vertical: true) }
                icon: { Image(systemName: "exclamationmark.circle").accessibilityHidden(true) }
                    .font(theme.typography.caption)
                    .foregroundStyle(theme.colors.error)
            }
        }
    }

    private var field: some View {
        ZStack(alignment: .leading) {
            if style == .floating {
                // A long inactive title must also participate in layout instead of overflowing an overlay.
                title.font(theme.typography.body)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(theme.spacing.md)
                    .hidden().accessibilityHidden(true)
            }
            content()
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.textPrimary)
                .padding(style == .stacked ? theme.spacing.lg : theme.spacing.md)
        }
        .frame(minHeight: style == .standard ? theme.controls.minimumTarget : theme.controls.minimumTarget + theme.spacing.md)
        .background(surface)
        .clipShape(shape)
        .overlay {
            shape.strokeBorder(borderColor, lineWidth: isFocused ? theme.controls.focusBorderWidth : theme.controls.borderWidth)
        }
        .overlay {
            if style == .floating {
                GeometryReader { geometry in
                    title.font(presentation.isLabelFloating ? theme.typography.caption : theme.typography.body)
                        .foregroundStyle(labelColor)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, presentation.isLabelFloating ? theme.spacing.xs : 0)
                        .background(surface)
                        .padding(.horizontal, theme.spacing.md)
                        .frame(width: geometry.size.width, alignment: .leading)
                        // Position the label's center on the border, independent of its text height.
                        .position(x: geometry.size.width / 2,
                                  y: presentation.isLabelFloating ? 0 : geometry.size.height / 2)
                }
                .allowsHitTesting(false)
                .accessibilityHidden(true)
            }
        }
        .shadow(color: style == .stacked ? theme.shadows.sm.color : .clear,
                radius: theme.shadows.sm.radius, x: theme.shadows.sm.x, y: theme.shadows.sm.y)
        .opacity(isEnabled ? 1 : theme.controls.disabledOpacity)
        .animation(reduceMotion ? nil : theme.animations.fast, value: presentation.isLabelFloating)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous)
    }

    private var surface: Color { style == .stacked ? theme.colors.background : theme.colors.surface }

    private var labelColor: Color {
        if case .error = state { return theme.colors.error }
        return isFocused ? theme.colors.primary : theme.colors.textSecondary
    }

    private var borderColor: Color {
        switch state {
        case .normal: isFocused ? theme.colors.primary : theme.colors.border
        case .success: theme.colors.success
        case .error: theme.colors.error
        }
    }
}
