import SwiftUI

/// A themed multiline text editor.
public struct IBTextEditor: View {
    @Environment(\.ironBitTheme) private var theme
    @Binding private var text: String
    private let minHeight: CGFloat

    /// Creates a text editor.
    public init(text: Binding<String>, minHeight: CGFloat = 120) {
        self._text = text
        self.minHeight = minHeight
    }

    /// The text editor body.
    public var body: some View {
        TextEditor(text: $text)
            .font(theme.typography.body)
            .frame(minHeight: minHeight)
            .padding(theme.spacing.sm)
            .background(theme.colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous)
                    .stroke(theme.colors.border, lineWidth: 1)
            )
    }
}

#Preview {
    @Previewable @State var text = "Ghi chú"
    return IBTextEditor(text: $text).padding()
}
