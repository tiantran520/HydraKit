import SwiftUI

/// A checkbox with parent-owned selection and native Toggle accessibility semantics.
public struct HKCheckbox: View {
    @Binding private var isOn: Bool
    private let title: Text

    /// Creates an enabled checkbox. Disable it with the native `.disabled` modifier.
    public init(_ title: String, isOn: Binding<Bool>) {
        self.init(Text(title), isOn: isOn)
    }

    /// Creates a checkbox with a localized Text label.
    public init(_ title: Text, isOn: Binding<Bool>) {
        self.title = title
        self._isOn = isOn
    }

    public var body: some View {
        Toggle(isOn: $isOn) { title }
            .toggleStyle(HKCheckboxToggleStyle())
    }
}

private struct HKCheckboxToggleStyle: ToggleStyle {
    @Environment(\.ironBitTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(alignment: .firstTextBaseline, spacing: theme.spacing.sm) {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundStyle(configuration.isOn ? theme.colors.primary : theme.colors.textSecondary)
                    .accessibilityHidden(true)
                configuration.label
                    .foregroundStyle(theme.colors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .font(theme.typography.body)
            .multilineTextAlignment(.leading)
            .frame(minWidth: theme.controls.minimumTarget, minHeight: theme.controls.minimumTarget, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .opacity(isEnabled ? 1 : theme.controls.disabledOpacity)
        .accessibilityRepresentation {
            Toggle(isOn: configuration.$isOn) { configuration.label }
                .toggleStyle(.automatic)
        }
    }
}

#Preview("Checkbox bindings and disabled state") {
    @Previewable @State var checked = true
    HKComponentPreview {
        HKCheckbox("Accept terms", isOn: $checked)
        HKCheckbox("Unchecked", isOn: .constant(false))
        HKCheckbox("Disabled selected", isOn: .constant(true)).disabled(true)
        HKCheckbox("A long localized consent label that must remain readable at larger text sizes", isOn: $checked)
    }
}
