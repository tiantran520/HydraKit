import SwiftUI

/// A component alias for skeleton placeholders.
public struct IBSkeleton: View {
    private let variant: SkeletonView.Variant

    /// Creates a skeleton component.
    public init(_ variant: SkeletonView.Variant = .line) {
        self.variant = variant
    }

    /// The skeleton body.
    public var body: some View {
        SkeletonView(variant)
    }
}

#Preview {
    VStack {
        IBSkeleton(.line)
        IBSkeleton(.card)
    }
    .padding()
}
