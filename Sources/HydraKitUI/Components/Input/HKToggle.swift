import SwiftUI

/// A native Toggle using the theme tint. Selection belongs to the parent.
public struct HKToggle: View {
    /// Compact changes typography while preserving the native interaction target.
    public enum HKVariant: Sendable { case standard, compact }

    @Environment(\.ironBitTheme) private var theme
    private let title: Text
    @Binding private var isOn: Bool
    private let variant: HKVariant

    /// Defaults to standard typography. Use `.disabled` for enabled state.
    public init(_ title: String, isOn: Binding<Bool>, variant: HKVariant = .standard) {
        self.init(Text(title), isOn: isOn, variant: variant)
    }

    /// Creates a toggle with a localized Text label.
    public init(_ title: Text, isOn: Binding<Bool>, variant: HKVariant = .standard) {
        self.title = title
        self._isOn = isOn
        self.variant = variant
    }

    public var body: some View {
        Toggle(isOn: $isOn) { title.fixedSize(horizontal: false, vertical: true) }
            .font(variant == .compact ? theme.typography.caption : theme.typography.body)
            .tint(theme.colors.primary)
            .frame(minHeight: theme.controls.minimumTarget)
    }
}

#Preview("Toggle variants and states") {
    @Previewable @State var isOn = true
    HKComponentPreview {
        HKToggle("Notifications", isOn: $isOn)
        HKToggle("Compact", isOn: $isOn, variant: .compact)
        HKToggle("Disabled", isOn: .constant(false)).disabled(true)
        HKToggle("A long localized preference label that wraps at narrow widths", isOn: $isOn)
    }
}
