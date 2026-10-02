import SwiftUI

/// A lightweight navigation bar.
public struct HKNavigationBar<Trailing: View>: View {
    @Environment(\.ironBitTheme) private var theme
    private let title: String
    private let trailing: Trailing

    /// Creates a navigation bar.
    public init(_ title: String, @ViewBuilder trailing: () -> Trailing = { EmptyView() }) {
        self.title = title
        self.trailing = trailing()
    }

    /// The navigation bar body.
    public var body: some View {
        HStack {
            Text(title)
                .font(theme.typography.title)
            Spacer()
            trailing
        }
        .padding(theme.spacing.md)
        .background(theme.colors.background)
    }
}

#Preview {
    HKNavigationBar("Trang chủ") {
        HKIcon("bell")
    }
}
