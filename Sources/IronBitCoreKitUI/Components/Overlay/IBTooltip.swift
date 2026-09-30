import SwiftUI

/// A small tooltip bubble.
public struct IBTooltip: View {
    @Environment(\.ironBitTheme) private var theme
    private let text: String

    /// Creates a tooltip.
    public init(_ text: String) {
        self.text = text
    }

    /// The tooltip body.
    public var body: some View {
        Text(text)
            .font(theme.typography.caption)
            .foregroundStyle(.white)
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xs)
            .background(.black.opacity(0.86))
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.sm, style: .continuous))
    }
}

#Preview {
    IBTooltip("Gợi ý").padding()
}
