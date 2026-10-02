import SwiftUI

/// A breadcrumb navigation display.
public struct HKBreadcrumb: View {
    @Environment(\.ironBitTheme) private var theme
    private let items: [String]

    /// Creates breadcrumbs.
    public init(_ items: [String]) {
        self.items = items
    }

    /// The breadcrumb body.
    public var body: some View {
        HStack(spacing: theme.spacing.xs) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                Text(item)
                    .font(theme.typography.caption)
                    .foregroundStyle(index == items.count - 1 ? theme.colors.textPrimary : theme.colors.textSecondary)
                if index < items.count - 1 {
                    Image(systemName: "chevron.right")
                        .font(theme.typography.caption)
                        .foregroundStyle(theme.colors.textSecondary)
                }
            }
        }
    }
}

#Preview {
    HKBreadcrumb(["Home", "Settings", "Profile"]).padding()
}
