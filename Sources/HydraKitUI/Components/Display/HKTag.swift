import SwiftUI

/// A small neutral tag.
public struct HKTag: View {
    @Environment(\.ironBitTheme) private var theme
    private let title: String

    /// Creates a tag.
    public init(_ title: String) {
        self.title = title
    }

    /// The tag body.
    public var body: some View {
        Text(title)
            .font(theme.typography.caption)
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xs)
            .foregroundStyle(theme.colors.textSecondary)
            .background(theme.colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.sm, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: theme.radius.sm, style: .continuous)
                    .stroke(theme.colors.border, lineWidth: 1)
            )
    }
}

#Preview {
    HKTag("SwiftUI").padding()
}
