import SwiftUI

/// A reusable loading state view.
public struct LoadingView: View {
    @Environment(\.ironBitTheme) private var theme
    private let title: String

    /// Creates a loading view.
    public init(_ title: String = "Đang tải") {
        self.title = title
    }

    /// The loading body.
    public var body: some View {
        VStack(spacing: theme.spacing.md) {
            ProgressView()
                .tint(theme.colors.primary)
            Text(title)
                .font(theme.typography.callout)
                .foregroundStyle(theme.colors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(theme.spacing.xl)
    }
}

#Preview {
    LoadingView()
}
