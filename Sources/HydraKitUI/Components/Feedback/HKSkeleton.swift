import SwiftUI

/// A component alias for skeleton placeholders.
public struct HKSkeleton: View {
    private let variant: SkeletonView.HKVariant

    /// Creates a skeleton component.
    public init(_ variant: SkeletonView.HKVariant = .line) {
        self.variant = variant
    }

    /// The skeleton body.
    public var body: some View {
        SkeletonView(variant)
    }
}

#Preview {
    VStack {
        HKSkeleton(.line)
        HKSkeleton(.card)
    }
    .padding()
}
