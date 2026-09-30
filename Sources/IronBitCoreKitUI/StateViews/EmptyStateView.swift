import SwiftUI

/// A reusable empty state view.
public struct EmptyStateView: View {
    @Environment(\.ironBitTheme) private var theme
    private let title: String
    private let message: String?
    private let systemImage: String

    /// Creates an empty state view.
    public init(title: String = "Chưa có dữ liệu", message: String? = nil, systemImage: String = "tray") {
        self.title = title
        self.message = message
        self.systemImage = systemImage
    }

    /// The empty state body.
    public var body: some View {
        VStack(spacing: theme.spacing.md) {
            Image(systemName: systemImage)
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(theme.colors.textSecondary)
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
    EmptyStateView(message: "Danh sách sẽ xuất hiện tại đây.")
}
