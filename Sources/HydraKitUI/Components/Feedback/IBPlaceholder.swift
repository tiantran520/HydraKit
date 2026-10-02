import SwiftUI

/// A neutral placeholder view.
public struct IBPlaceholder: View {
    @Environment(\.ironBitTheme) private var theme
    private let title: String
    private let systemImage: String

    /// Creates a placeholder.
    public init(_ title: String = "Không có nội dung", systemImage: String = "square.dashed") {
        self.title = title
        self.systemImage = systemImage
    }

    /// The placeholder body.
    public var body: some View {
        VStack(spacing: theme.spacing.sm) {
            Image(systemName: systemImage)
                .font(.title)
            Text(title)
                .font(theme.typography.callout)
        }
        .foregroundStyle(theme.colors.textSecondary)
        .padding(theme.spacing.lg)
    }
}

#Preview {
    IBPlaceholder().padding()
}
