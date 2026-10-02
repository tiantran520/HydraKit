import SwiftUI

/// Primary themed SwiftUI button style.
public struct IBPrimaryButtonStyle: ButtonStyle {
    @Environment(\.ironBitTheme) private var theme

    /// Creates the style.
    public init() {}

    /// Builds the styled button body.
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.typography.button)
            .frame(minHeight: 44)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, theme.spacing.lg)
            .foregroundStyle(.white)
            .background(theme.colors.primary.opacity(configuration.isPressed ? 0.82 : 1))
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(theme.animations.fast, value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == IBPrimaryButtonStyle {
    /// Hydra primary button style.
    static var ibPrimary: IBPrimaryButtonStyle { IBPrimaryButtonStyle() }
}
