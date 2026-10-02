import SwiftUI

/// A full-width inline banner.
public struct IBBanner: View {
    /// Banner variants.
    public enum HKVariant: Sendable {
        /// Info banner.
        case info
        /// Warning banner.
        case warning
        /// Error banner.
        case error
    }

    @Environment(\.ironBitTheme) private var theme
    private let title: String
    private let message: String?
    private let variant: HKVariant

    /// Creates a banner.
    public init(title: String, message: String? = nil, variant: HKVariant = .info) {
        self.title = title
        self.message = message
        self.variant = variant
    }

    /// The banner body.
    public var body: some View {
        HStack(alignment: .top, spacing: theme.spacing.md) {
            Image(systemName: icon)
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: theme.spacing.xs) {
                Text(title).font(theme.typography.headline)
                if let message {
                    Text(message).font(theme.typography.callout)
                }
            }
            Spacer()
        }
        .padding(theme.spacing.md)
        .background(color.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous))
    }

    private var color: Color {
        switch variant {
        case .info: theme.colors.primary
        case .warning: theme.colors.warning
        case .error: theme.colors.error
        }
    }

    private var icon: String {
        switch variant {
        case .info: "info.circle.fill"
        case .warning: "exclamationmark.triangle.fill"
        case .error: "xmark.octagon.fill"
        }
    }
}

#Preview {
    IBBanner(title: "Thông báo", message: "Có bản cập nhật mới.").padding()
}
