import SwiftUI

/// Overlays a loading indicator over content.
public struct IBLoadingOverlay<Content: View>: View {
    @Environment(\.ironBitTheme) private var theme
    private let isLoading: Bool
    private let content: Content

    /// Creates a loading overlay.
    public init(isLoading: Bool, @ViewBuilder content: () -> Content) {
        self.isLoading = isLoading
        self.content = content()
    }

    /// The overlay body.
    public var body: some View {
        content
            .overlay {
                if isLoading {
                    ZStack {
                        theme.colors.background.opacity(0.72)
                        IBProgressView()
                    }
                }
            }
    }
}

#Preview {
    IBLoadingOverlay(isLoading: true) {
        IBCard { Text("Đang xử lý") }
    }
    .padding()
}
