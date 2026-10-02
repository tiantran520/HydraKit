import SwiftUI

/// A themed radio button bound to a selected value.
public struct IBRadioButton<Value: Hashable>: View {
    @Environment(\.ironBitTheme) private var theme
    private let title: String
    private let value: Value
    @Binding private var selection: Value

    /// Creates a radio button.
    public init(_ title: String, value: Value, selection: Binding<Value>) {
        self.title = title
        self.value = value
        self._selection = selection
    }

    /// The radio button body.
    public var body: some View {
        Button {
            selection = value
        } label: {
            HStack(spacing: theme.spacing.sm) {
                Image(systemName: selection == value ? "largecircle.fill.circle" : "circle")
                    .foregroundStyle(selection == value ? theme.colors.primary : theme.colors.textSecondary)
                Text(title)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var selection = "A"
    return VStack {
        IBRadioButton("A", value: "A", selection: $selection)
        IBRadioButton("B", value: "B", selection: $selection)
    }
    .padding()
}
