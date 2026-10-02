import SwiftUI

/// A reusable error state view.
public struct ErrorStateView: View {
    @Environment(\.ironBitTheme) private var theme
    private let title: String
    private let message: String?

    /// Creates an error state view.
    public init(title: String = "Đã xảy ra lỗi", message: String? = nil) {
        self.title = title
        self.message = message
    }

    /// The error state body.
    public var body: some View {
        VStack(spacing: theme.spacing.md) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(theme.colors.error)
            Text(title)
                .font(theme.typography.headline)
            if let message {
                Text(message)
                    .font(theme.typography.callout)
                    .foregroundStyle(theme.colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(theme.spacing.xl)
    }
}

#Preview {
    ErrorStateView(message: "Vui lòng thử lại sau.")
}
