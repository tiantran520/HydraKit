import SwiftUI

/// A themed checkbox.
public struct IBCheckbox: View {
    @Environment(\.ironBitTheme) private var theme
    @Binding private var isOn: Bool
    private let title: String

    /// Creates a checkbox.
    public init(_ title: String, isOn: Binding<Bool>) {
        self.title = title
        self._isOn = isOn
    }

    /// The checkbox body.
    public var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack(spacing: theme.spacing.sm) {
                Image(systemName: isOn ? "checkmark.square.fill" : "square")
                    .foregroundStyle(isOn ? theme.colors.primary : theme.colors.textSecondary)
                Text(title)
                    .foregroundStyle(theme.colors.textPrimary)
            }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }
}

#Preview {
    @Previewable @State var checked = true
    return IBCheckbox("Đồng ý điều khoản", isOn: $checked).padding()
}
