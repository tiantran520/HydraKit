import SwiftUI

/// A small status badge.
public struct HKBadge: View {
    /// Semantic badge variants.
    public enum HKVariant: Sendable {
        /// Neutral badge.
        case neutral
        /// Success badge.
        case success
        /// Warning badge.
        case warning
        /// Error badge.
        case error
    }

    @Environment(\.ironBitTheme) private var theme
    private let title: String
    private let variant: HKVariant

    /// Creates a badge.
    public init(_ title: String, variant: HKVariant = .neutral) {
        self.title = title
        self.variant = variant
    }

    /// The badge body.
    public var body: some View {
        Text(title)
            .font(theme.typography.caption.weight(.bold))
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xs)
            .foregroundStyle(.white)
            .background(color)
            .clipShape(Capsule())
    }

    private var color: Color {
        switch variant {
        case .neutral: theme.colors.secondary
        case .success: theme.colors.success
        case .warning: theme.colors.warning
        case .error: theme.colors.error
        }
    }
}

#Preview {
    HStack {
        HKBadge("New")
        HKBadge("Done", variant: .success)
        HKBadge("Warn", variant: .warning)
        HKBadge("Fail", variant: .error)
    }
    .padding()
}
