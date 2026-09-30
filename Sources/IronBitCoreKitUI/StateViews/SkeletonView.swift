import SwiftUI

/// A placeholder skeleton row or block.
public struct SkeletonView: View {
    /// Skeleton variants.
    public enum Variant: Sendable {
        /// Text-line skeleton.
        case line
        /// Card skeleton.
        case card
        /// Circular avatar skeleton.
        case avatar
    }

    @Environment(\.ironBitTheme) private var theme
    private let variant: Variant

    /// Creates a skeleton view.
    public init(_ variant: Variant = .line) {
        self.variant = variant
    }

    /// The skeleton body.
    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(theme.colors.border.opacity(0.35))
            .frame(height: height)
            .clipShape(shape)
            .shimmer()
    }

    private var height: CGFloat {
        switch variant {
        case .line: 14
        case .card: 96
        case .avatar: 44
        }
    }

    private var cornerRadius: CGFloat {
        variant == .avatar ? theme.radius.pill : theme.radius.sm
    }

    private var shape: AnyShape {
        variant == .avatar ? AnyShape(Circle()) : AnyShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

#Preview {
    VStack {
        SkeletonView(.avatar).frame(width: 44)
        SkeletonView(.line)
        SkeletonView(.card)
    }
    .padding()
}
