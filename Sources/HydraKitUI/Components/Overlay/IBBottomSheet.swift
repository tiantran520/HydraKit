import SwiftUI

/// A bottom sheet container.
public struct IBBottomSheet<Content: View>: View {
    @Environment(\.ironBitTheme) private var theme
    private let content: Content

    /// Creates a bottom sheet.
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    /// The bottom sheet body.
    public var body: some View {
        VStack(spacing: theme.spacing.md) {
            Capsule()
                .fill(theme.colors.border)
                .frame(width: 40, height: 5)
            content
        }
        .padding(theme.spacing.lg)
        .frame(maxWidth: .infinity)
        .background(theme.colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg, style: .continuous))
    }
}

#Preview {
    IBBottomSheet {
        Text("Bottom sheet")
    }
    .padding()
}
