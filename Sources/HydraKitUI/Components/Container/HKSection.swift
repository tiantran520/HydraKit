import SwiftUI

/// A themed section container.
public struct HKSection<Content: View>: View {
    @Environment(\.ironBitTheme) private var theme
    private let title: String?
    private let content: Content

    /// Creates a section.
    public init(_ title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    /// The section body.
    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            if let title {
                Text(title)
                    .font(theme.typography.headline)
            }
            content
        }
    }
}

#Preview {
    HKSection("Thông tin") {
        HKCard { Text("Nội dung") }
    }
    .padding()
}
