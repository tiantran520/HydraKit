import SwiftUI

/// A themed scroll view wrapper.
public struct HKScrollView<Content: View>: View {
    @Environment(\.ironBitTheme) private var theme
    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let content: Content

    /// Creates a scroll view.
    public init(_ axes: Axis.Set = .vertical, showsIndicators: Bool = true, @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content()
    }

    /// The scroll view body.
    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            content
                .padding(theme.spacing.md)
        }
    }
}

#Preview {
    HKScrollView {
        VStack {
            ForEach(0..<5) { Text("Dòng \($0)") }
        }
    }
}
