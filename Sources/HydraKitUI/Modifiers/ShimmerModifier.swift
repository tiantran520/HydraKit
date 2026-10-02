import SwiftUI

/// Adds a lightweight shimmer effect.
public struct ShimmerModifier: ViewModifier {
    @State private var isActive = false

    /// Creates a shimmer modifier.
    public init() {}

    /// Applies the shimmer effect.
    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.45), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .rotationEffect(.degrees(20))
                    .offset(x: isActive ? proxy.size.width : -proxy.size.width)
                }
                .clipped()
                .allowsHitTesting(false)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.1).repeatForever(autoreverses: false)) {
                    isActive = true
                }
            }
    }
}

public extension View {
    /// Applies a shimmer effect.
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
