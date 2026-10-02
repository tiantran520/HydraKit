import SwiftUI

/// A themed text view.
public struct HKText: View {
    /// Text style variants.
    public enum HKVariant: Sendable {
        /// Title text.
        case title
        /// Headline text.
        case headline
        /// Body text.
        case body
        /// Caption text.
        case caption
    }

    @Environment(\.ironBitTheme) private var theme
    private let value: String
    private let variant: HKVariant

    /// Creates themed text.
    public init(_ value: String, variant: HKVariant = .body) {
        self.value = value
        self.variant = variant
    }

    /// The text body.
    public var body: some View {
        Text(value)
            .font(font)
            .foregroundStyle(theme.colors.textPrimary)
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

#Preview {
    VStack(alignment: .leading) {
        HKText("Title", variant: .title)
        HKText("Body")
        HKText("Caption", variant: .caption)
    }
    .padding()
}
