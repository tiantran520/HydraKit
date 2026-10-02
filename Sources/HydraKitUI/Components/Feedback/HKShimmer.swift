import SwiftUI

/// A wrapper that applies shimmer to content.
public struct HKShimmer<Content: View>: View {
    private let content: Content

    /// Creates a shimmer wrapper.
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    /// The shimmer body.
    public var body: some View {
        content.shimmer()
    }
}

#Preview {
    HKShimmer {
        RoundedRectangle(cornerRadius: 8).fill(.gray.opacity(0.25)).frame(height: 80)
    }
    .padding()
}
