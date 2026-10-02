import SwiftUI

/// A themed link.
public struct IBLink: View {
    @Environment(\.ironBitTheme) private var theme
    private let title: String
    private let url: URL

    /// Creates a link.
    public init(_ title: String, url: URL) {
        self.title = title
        self.url = url
    }

    /// The link body.
    public var body: some View {
        Link(destination: url) {
            HStack(spacing: theme.spacing.xs) {
                Text(title)
                Image(systemName: "arrow.up.right")
            }
            .font(theme.typography.callout.weight(.semibold))
            .foregroundStyle(theme.colors.primary)
        }
    }
}

#Preview {
    IBLink("Hydra", url: URL(string: "https://example.com")!).padding()
}
