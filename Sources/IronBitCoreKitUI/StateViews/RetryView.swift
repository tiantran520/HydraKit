import SwiftUI

/// A reusable error state with a retry action.
public struct RetryView: View {
    @Environment(\.ironBitTheme) private var theme
    private let title: String
    private let message: String?
    private let retryTitle: String
    private let retry: @MainActor () -> Void

    /// Creates a retry view.
    public init(
        title: String = "Không thể tải dữ liệu",
        message: String? = nil,
        retryTitle: String = "Thử lại",
        retry: @escaping @MainActor () -> Void
    ) {
        self.title = title
        self.message = message
        self.retryTitle = retryTitle
        self.retry = retry
    }

    /// The retry body.
    public var body: some View {
        VStack(spacing: theme.spacing.lg) {
            ErrorStateView(title: title, message: message)
                .frame(maxHeight: 220)
            IBButton(retryTitle, variant: .primary, action: retry)
                .frame(maxWidth: 220)
        }
        .padding(theme.spacing.xl)
    }
}

#Preview {
    RetryView(message: "Mạng không ổn định.") {}
}
