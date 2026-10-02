import SwiftUI

/// A centered modal container.
public struct HKModal<Content: View>: View {
    @Environment(\.ironBitTheme) private var theme
    private let title: String?
    private let content: Content

    /// Creates a modal.
    public init(title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    /// The modal body.
    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            if let title {
                Text(title).font(theme.typography.title)
            }
            content
        }
        .padding(theme.spacing.lg)
        .background(theme.colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg, style: .continuous))
        .shadow(color: theme.shadows.md.color, radius: theme.shadows.md.radius, x: theme.shadows.md.x, y: theme.shadows.md.y)
    }
}

#Preview {
    HKModal(title: "Xác nhận") {
        Text("Bạn muốn tiếp tục?")
    }
    .padding()
}
