import SwiftUI

/// Overlays a loading indicator over content.
public struct HKLoadingOverlay<Content: View>: View {
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
                        HKProgressView()
                    }
                }
            }
    }
}

#Preview {
    HKLoadingOverlay(isLoading: true) {
        HKCard { Text("Đang xử lý") }
    }
    .padding()
}
