import SwiftUI

/// A themed secure text field.
public struct IBSecureField: View {
    @Environment(\.ironBitTheme) private var theme
    private let title: String
    @Binding private var text: String

    /// Creates a secure field.
    public init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }

    /// The secure field body.
    public var body: some View {
        SecureField(title, text: $text)
            .font(theme.typography.body)
            .padding(theme.spacing.md)
            .background(theme.colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous)
                    .stroke(theme.colors.border, lineWidth: 1)
            )
    }
}

#Preview {
    @Previewable @State var password = "secret"
    return IBSecureField("Mật khẩu", text: $password).padding()
}
