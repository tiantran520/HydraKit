import SwiftUI

/// A compact toast message.
public struct IBToast: View {
    /// Toast variants.
    public enum Variant: Sendable {
        /// Informational toast.
        case info
        /// Success toast.
        case success
        /// Error toast.
        case error
    }

    @Environment(\.ironBitTheme) private var theme
    private let message: String
    private let variant: Variant

    /// Creates a toast.
    public init(_ message: String, variant: Variant = .info) {
        self.message = message
        self.variant = variant
    }

    /// The toast body.
    public var body: some View {
        Text(message)
            .font(theme.typography.callout)
            .foregroundStyle(.white)
            .padding(.horizontal, theme.spacing.lg)
            .padding(.vertical, theme.spacing.md)
            .background(color)
            .clipShape(Capsule())
            .shadow(radius: 8)
    }

    private var color: Color {
        switch variant {
        case .info: theme.colors.secondary
        case .success: theme.colors.success
        case .error: theme.colors.error
        }
    }
}

#Preview {
    IBToast("Đã lưu", variant: .success).padding()
}
