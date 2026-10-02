import SwiftUI

/// A simple themed tab bar.
public struct HKTabBar<Item: Hashable>: View {
    @Environment(\.ironBitTheme) private var theme
    private let items: [(Item, String, String)]
    @Binding private var selection: Item

    /// Creates a tab bar.
    public init(items: [(Item, String, String)], selection: Binding<Item>) {
        self.items = items
        self._selection = selection
    }

    /// The tab bar body.
    public var body: some View {
        HStack {
            ForEach(items, id: \.0) { item in
                Button {
                    selection = item.0
                } label: {
                    VStack(spacing: theme.spacing.xs) {
                        Image(systemName: item.2)
                        Text(item.1).font(theme.typography.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(selection == item.0 ? theme.colors.primary : theme.colors.textSecondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, theme.spacing.sm)
        .background(theme.colors.surface)
    }
}

#Preview {
    @Previewable @State var selection = "home"
    return HKTabBar(items: [("home", "Home", "house"), ("settings", "Settings", "gear")], selection: $selection)
}
