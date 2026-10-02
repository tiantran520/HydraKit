import SwiftUI

/// A themed adaptive grid.
public struct IBGrid<Content: View>: View {
    private let minItemWidth: CGFloat
    private let spacing: CGFloat
    private let content: Content

    /// Creates a grid.
    public init(minItemWidth: CGFloat = 140, spacing: CGFloat = 12, @ViewBuilder content: () -> Content) {
        self.minItemWidth = minItemWidth
        self.spacing = spacing
        self.content = content()
    }

    /// The grid body.
    public var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: minItemWidth), spacing: spacing)], spacing: spacing) {
            content
        }
    }
}

#Preview {
    IBGrid {
        ForEach(0..<4) { index in
            IBCard { Text("Item \(index)") }
        }
    }
    .padding()
}
