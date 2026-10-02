import SwiftUI

/// A themed row container.
public struct HKRow<Leading: View, Trailing: View>: View {
    @Environment(\.ironBitTheme) private var theme
    private let leading: Leading
    private let trailing: Trailing

    /// Creates a row.
    public init(@ViewBuilder leading: () -> Leading, @ViewBuilder trailing: () -> Trailing) {
        self.leading = leading()
        self.trailing = trailing()
    }

    /// The row body.
    public var body: some View {
        HStack(spacing: theme.spacing.md) {
            leading
            Spacer()
            trailing
        }
        .padding(.vertical, theme.spacing.sm)
    }
}

#Preview {
    HKRow {
        Text("Tên")
    } trailing: {
        HKBadge("Mới")
    }
    .padding()
}
