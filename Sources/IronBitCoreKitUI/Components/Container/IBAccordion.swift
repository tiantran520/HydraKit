import SwiftUI

/// A themed accordion.
public struct IBAccordion<Content: View>: View {
    @Environment(\.ironBitTheme) private var theme
    @State private var isExpanded: Bool
    private let title: String
    private let content: Content

    /// Creates an accordion.
    public init(_ title: String, isExpanded: Bool = false, @ViewBuilder content: () -> Content) {
        self.title = title
        self._isExpanded = State(initialValue: isExpanded)
        self.content = content()
    }

    /// The accordion body.
    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Button {
                withAnimation(theme.animations.fast) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(title).font(theme.typography.headline)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                content
                    .transition(.ibFadeScale)
            }
        }
        .ibCardStyle(.outlined)
    }
}

#Preview {
    IBAccordion("Chi tiết", isExpanded: true) {
        Text("Nội dung mở rộng")
    }
    .padding()
}
