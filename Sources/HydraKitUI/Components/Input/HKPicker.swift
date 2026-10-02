import SwiftUI

/// A themed picker for hashable values.
public struct HKPicker<Value: Hashable>: View {
    @Environment(\.ironBitTheme) private var theme
    private let title: String
    private let options: [(Value, String)]
    @Binding private var selection: Value

    /// Creates a picker.
    public init(_ title: String, selection: Binding<Value>, options: [(Value, String)]) {
        self.title = title
        self._selection = selection
        self.options = options
    }

    /// The picker body.
    public var body: some View {
        Picker(title, selection: $selection) {
            ForEach(options, id: \.0) { option in
                Text(option.1).tag(option.0)
            }
        }
        .tint(theme.colors.primary)
    }
}

#Preview {
    @Previewable @State var value = "dev"
    return HKPicker("Env", selection: $value, options: [("dev", "Dev"), ("prod", "Prod")]).padding()
}
