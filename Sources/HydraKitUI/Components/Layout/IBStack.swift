import SwiftUI

/// A themed stack that can switch axis.
public struct IBStack<Content: View>: View {
    /// Stack axis.
    public enum HKAxis: Sendable {
        /// Horizontal axis.
        case horizontal
        /// Vertical axis.
        case vertical
    }

    @Environment(\.ironBitTheme) private var theme
    private let axis: HKAxis
    private let spacing: CGFloat?
    private let content: Content

    /// Creates a stack.
    public init(_ axis: HKAxis = .vertical, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.axis = axis
        self.spacing = spacing
        self.content = content()
    }

    /// The stack body.
    public var body: some View {
        switch axis {
        case .horizontal:
            HStack(spacing: spacing ?? theme.spacing.md) { content }
        case .vertical:
            VStack(spacing: spacing ?? theme.spacing.md) { content }
        }
    }
}

#Preview {
    IBStack(.horizontal) {
        IBChip("A")
        IBChip("B")
    }
    .padding()
}
