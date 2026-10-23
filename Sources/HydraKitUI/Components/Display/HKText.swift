import SwiftUI

/// Theme typography applied to plain, localized, or attributed Text content.
public struct HKText: View {
    /// Typography roles resolved from the current theme.
    public enum HKVariant: Sendable { case title, headline, body, caption }

    @Environment(\.ironBitTheme) private var theme
    @Environment(\.lineLimit) private var inheritedLineLimit
    @Environment(\.multilineTextAlignment) private var inheritedAlignment
    private let value: Text
    private let variant: HKVariant
    private let color: Color?
    private let alignment: TextAlignment?
    private let lineLimit: Int?

    /// Creates text. Defaults: body, theme textPrimary, leading, unlimited lines.
    /// Strings are displayed verbatim; pass Text("catalog.key") for localization.
    /// Preserves the original initializer, including use as a function reference.
    public init(_ value: String, variant: HKVariant = .body) {
        self.init(value, variant: variant, color: nil)
    }

    /// Creates text with optional typography, color, alignment, and line-limit overrides.
    public init(
        _ value: String, variant: HKVariant = .body, color: Color? = nil,
        alignment: TextAlignment? = nil, lineLimit: Int? = nil
    ) {
        self.init(Text(value), variant: variant, color: color, alignment: alignment, lineLimit: lineLimit)
    }

    /// Creates themed content from Text, preserving localization and interpolation.
    public init(
        _ value: Text, variant: HKVariant = .body, color: Color? = nil,
        alignment: TextAlignment? = nil, lineLimit: Int? = nil
    ) {
        self.value = value
        self.variant = variant
        self.color = color
        self.alignment = alignment
        self.lineLimit = lineLimit
    }

    public var body: some View {
        value
            .font(font)
            .foregroundStyle(color ?? theme.colors.textPrimary)
            .multilineTextAlignment(alignment ?? inheritedAlignment)
            .lineLimit(lineLimit ?? inheritedLineLimit)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var font: Font {
        switch variant {
        case .title: theme.typography.title
        case .headline: theme.typography.headline
        case .body: theme.typography.body
        case .caption: theme.typography.caption
        }
    }
}

#Preview("Text roles and wrapping") {
    HKComponentPreview {
        HKText("Title", variant: .title)
        HKText("Headline", variant: .headline)
        HKText("A long localized paragraph that wraps naturally as the available width or preferred text size changes.")
        HKText("Caption", variant: .caption)
        HKText("A limited paragraph that can be truncated intentionally by the caller.", lineLimit: 1)
    }
}
