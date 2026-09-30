import SwiftUI

/// A themed progress view.
public struct IBProgressView: View {
    /// Progress variants.
    public enum Variant: Sendable {
        /// Circular progress.
        case circular
        /// Linear progress.
        case linear(Double?)
    }

    @Environment(\.ironBitTheme) private var theme
    private let title: String?
    private let variant: Variant

    /// Creates a progress view.
    public init(_ title: String? = nil, variant: Variant = .circular) {
        self.title = title
        self.variant = variant
    }

    /// The progress body.
    public var body: some View {
        VStack(spacing: theme.spacing.sm) {
            switch variant {
            case .circular:
                ProgressView()
                    .tint(theme.colors.primary)
            case let .linear(value):
                ProgressView(value: value)
                    .tint(theme.colors.primary)
            }
            if let title {
                Text(title)
                    .font(theme.typography.caption)
                    .foregroundStyle(theme.colors.textSecondary)
            }
        }
    }
}

#Preview {
    VStack {
        IBProgressView("Đang tải")
        IBProgressView(variant: .linear(0.45))
    }
    .padding()
}
