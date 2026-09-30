import SwiftUI

/// A simple adaptive grid container.
public struct IBGridLayout<Content: View>: View {
    private let minItemWidth: CGFloat
    private let spacing: CGFloat
    private let content: Content

    /// Creates a grid layout.
    public init(minItemWidth: CGFloat = 160, spacing: CGFloat = 12, @ViewBuilder content: () -> Content) {
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
