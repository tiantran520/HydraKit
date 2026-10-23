import SwiftUI

/// Semantic symbol placement; follows the layout direction in right-to-left languages.
public enum HKIconPlacement: Sendable { case leading, trailing }

/// A native Label with themed typography and a decorative system symbol.
public struct HKLabel: View {
    @Environment(\.ironBitTheme) private var theme
    @Environment(\.lineLimit) private var inheritedLineLimit
    @Environment(\.multilineTextAlignment) private var inheritedAlignment
    private let title: Text
    private let systemImage: String
    private let iconPlacement: HKIconPlacement?
    private let font: Font?
    private let color: Color?
    private let alignment: TextAlignment?
    private let lineLimit: Int?
    private var inheritsStyle = false

    /// Defaults: leading symbol, theme body/textPrimary, leading alignment, unlimited lines.
    /// Preserves the original initializer and inherited native LabelStyle.
    public init(_ title: String, systemImage: String) {
        self.init(Text(title), systemImage: systemImage)
    }

    /// Creates a label with optional icon placement and text appearance overrides.
    public init(
        _ title: String, systemImage: String, iconPlacement: HKIconPlacement? = nil,
        font: Font? = nil, color: Color? = nil,
        alignment: TextAlignment? = nil, lineLimit: Int? = nil
    ) {
        self.init(Text(title), systemImage: systemImage, iconPlacement: iconPlacement,
                  font: font, color: color, alignment: alignment, lineLimit: lineLimit)
    }

    /// Accepts localized or attributed Text as the title.
    public init(
        _ title: Text, systemImage: String, iconPlacement: HKIconPlacement? = nil,
        font: Font? = nil, color: Color? = nil,
        alignment: TextAlignment? = nil, lineLimit: Int? = nil
    ) {
        self.title = title
        self.systemImage = systemImage
        self.iconPlacement = iconPlacement
        self.font = font
        self.color = color
        self.alignment = alignment
        self.lineLimit = lineLimit
    }

    // Button labels inherit foreground and typography from their ButtonStyle.
    init(_ title: String, systemImage: String, iconPlacement: HKIconPlacement, inheritsStyle: Bool) {
        self.init(title, systemImage: systemImage, iconPlacement: iconPlacement)
        self.inheritsStyle = inheritsStyle
    }

    @ViewBuilder public var body: some View {
        if inheritsStyle {
            content
        } else {
            content.font(font ?? theme.typography.body)
                .foregroundStyle(color ?? theme.colors.textPrimary)
        }
    }

    @ViewBuilder private var content: some View {
        if let iconPlacement {
            nativeLabel.labelStyle(HKPositionedLabelStyle(placement: iconPlacement, spacing: theme.spacing.sm))
        } else {
            nativeLabel
        }
    }

    private var nativeLabel: some View {
        Label {
            title.multilineTextAlignment(alignment ?? inheritedAlignment)
                .lineLimit(lineLimit ?? inheritedLineLimit)
                .fixedSize(horizontal: false, vertical: true)
        } icon: {
            Image(systemName: systemImage).accessibilityHidden(true)
        }
    }
}

private struct HKPositionedLabelStyle: LabelStyle {
    let placement: HKIconPlacement
    let spacing: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: spacing) {
            if placement == .leading { configuration.icon }
            configuration.title.layoutPriority(1)
            if placement == .trailing { configuration.icon }
        }
    }
}

#Preview("Label placement and long content") {
    HKComponentPreview {
        HKLabel("Profile", systemImage: "person.crop.circle")
        HKLabel("Continue", systemImage: "arrow.right", iconPlacement: .trailing)
        HKLabel("A long localized title that wraps without shrinking its symbol", systemImage: "info.circle")
    }
}
