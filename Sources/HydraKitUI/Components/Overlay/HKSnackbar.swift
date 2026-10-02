import SwiftUI

/// A snackbar with an optional action.
public struct HKSnackbar: View {
    @Environment(\.ironBitTheme) private var theme
    private let message: String
    private let actionTitle: String?
    private let action: (@MainActor () -> Void)?

    /// Creates a snackbar.
    public init(_ message: String, actionTitle: String? = nil, action: (@MainActor () -> Void)? = nil) {
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    /// The snackbar body.
    public var body: some View {
        HStack(spacing: theme.spacing.md) {
            Text(message)
                .font(theme.typography.callout)
                .foregroundStyle(.white)
            Spacer()
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(theme.typography.button)
                    .foregroundStyle(theme.colors.accent)
            }
        }
        .padding(theme.spacing.md)
        .background(.black.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous))
    }
}

#Preview {
    HKSnackbar("Không có kết nối", actionTitle: "Thử lại") {}
        .padding()
}
