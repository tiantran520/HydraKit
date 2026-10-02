import SwiftUI

/// A themed search bar.
public struct IBSearchBar: View {
    @Environment(\.ironBitTheme) private var theme
    @Binding private var text: String
    private let placeholder: String

    /// Creates a search bar.
    public init(_ placeholder: String = "Tìm kiếm", text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    /// The search bar body.
    public var body: some View {
        HStack(spacing: theme.spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(theme.colors.textSecondary)
            TextField(placeholder, text: $text)
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .buttonStyle(.plain)
                .foregroundStyle(theme.colors.textSecondary)
            }
        }
        .font(theme.typography.body)
        .padding(theme.spacing.md)
        .background(theme.colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous))
    }
}

#Preview {
    @Previewable @State var query = "Iron"
    return IBSearchBar(text: $query).padding()
}
