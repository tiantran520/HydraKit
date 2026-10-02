import SwiftUI

/// A themed text field with validation state variants.
public struct IBTextField: View {
    /// Visual state for the field.
    public enum State: Sendable {
        /// Normal input state.
        case normal
        /// Successful validation state.
        case success
        /// Error validation state.
        case error(String?)
    }

    @Environment(\.ironBitTheme) private var theme
    private let title: String
    @Binding private var text: String
    private let state: State

    /// Creates a themed text field.
    public init(_ title: String, text: Binding<String>, state: State = .normal) {
        self.title = title
        self._text = text
        self.state = state
    }

    /// The text field body.
    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            TextField(title, text: $text)
                .font(theme.typography.body)
                .padding(theme.spacing.md)
                .background(theme.colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous)
                        .stroke(borderColor, lineWidth: 1)
                )

            if case let .error(message?) = state {
                Text(message)
                    .font(theme.typography.caption)
                    .foregroundStyle(theme.colors.error)
            }
        }
    }

    private var borderColor: Color {
        switch state {
        case .normal: theme.colors.border
        case .success: theme.colors.success
        case .error: theme.colors.error
        }
    }
}

#Preview {
    @Previewable @State var text = "hello@hydra.dev"
    return IBTextField("Email", text: $text, state: .success)
        .padding()
}
