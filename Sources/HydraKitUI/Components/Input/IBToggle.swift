import SwiftUI

/// A themed toggle.
public struct IBToggle: View {
    /// Toggle variants.
    public enum HKVariant: Sendable {
        /// Standard switch.
        case standard
        /// Compact switch.
        case compact
    }

    @Environment(\.ironBitTheme) private var theme
    private let title: String
    @Binding private var isOn: Bool
    private let variant: HKVariant

    /// Creates a toggle.
    public init(_ title: String, isOn: Binding<Bool>, variant: HKVariant = .standard) {
        self.title = title
        self._isOn = isOn
        self.variant = variant
    }

    /// The toggle body.
    public var body: some View {
        Toggle(title, isOn: $isOn)
            .font(variant == .compact ? theme.typography.caption : theme.typography.body)
            .tint(theme.colors.primary)
    }
}

#Preview {
    @Previewable @State var isOn = true
    return IBToggle("Thông báo", isOn: $isOn)
        .padding()
}
