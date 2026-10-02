import SwiftUI

/// A stack that switches between horizontal and vertical layouts.
public struct AdaptiveStack<Content: View>: View {
    /// Adaptive stack axis.
    public enum HKAxis: Sendable {
        /// Horizontal stack first.
        case horizontal
        /// Vertical stack first.
        case vertical
    }

    private let axis: HKAxis
    private let spacing: CGFloat
    private let content: Content

    /// Creates an adaptive stack.
    public init(axis: HKAxis = .horizontal, spacing: CGFloat = 12, @ViewBuilder content: () -> Content) {
        self.axis = axis
        self.spacing = spacing
        self.content = content()
    }

    /// The adaptive body.
    public var body: some View {
        ViewThatFits {
            if axis == .horizontal {
                HStack(spacing: spacing) { content }
                VStack(spacing: spacing) { content }
            } else {
                VStack(spacing: spacing) { content }
                HStack(spacing: spacing) { content }
            }
        }
    }
}
