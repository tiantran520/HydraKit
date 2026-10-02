import SwiftUI

/// A themed form container.
public struct FormView<Content: View>: View {
    @Environment(\.ironBitTheme) private var theme
    private let title: String?
    private let content: Content

    /// Creates a form view.
    public init(title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    /// The form body.
    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.lg) {
            if let title {
                Text(title)
                    .font(theme.typography.title)
            }
            content
        }
        .padding(theme.spacing.lg)
    }
}

#Preview {
    @Previewable @State var name = ""
    return FormView(title: "Hồ sơ") {
        IBTextField("Tên", text: $name)
        IBButton("Lưu") {}
    }
}
