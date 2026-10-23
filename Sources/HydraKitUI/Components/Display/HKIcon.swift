import SwiftUI

/// A scalable SF Symbol. Preserves native symbol semantics; provide an accessibility label for app-specific meaning.
public struct HKIcon: View {
    /// Default point sizes; themes may replace these metrics through ControlTokens.
    public enum HKSize: CGFloat, Sendable { case sm = 16, md = 22, lg = 32 }

    @Environment(\.ironBitTheme) private var theme
    @ScaledMetric(relativeTo: .body) private var scale: CGFloat = 1
    private let name: String
    private let size: HKSize
    private let color: Color?
    private let renderingMode: SymbolRenderingMode?
    private let accessibilityLabel: Text?

    /// Defaults: medium, theme primary, native rendering, native accessibility.
    /// Preserves the original symbol initializer, including factory references.
    public init(_ name: String, size: HKSize = .md) {
        self.init(name, size: size, color: nil)
    }

    /// Creates a symbol with optional color, rendering, and accessibility overrides.
    public init(
        _ name: String, size: HKSize = .md, color: Color? = nil,
        renderingMode: SymbolRenderingMode? = nil, accessibilityLabel: Text? = nil
    ) {
        self.name = name
        self.size = size
        self.color = color
        self.renderingMode = renderingMode
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        symbol
            .font(.system(size: points * scale, weight: .semibold))
            .foregroundStyle(color ?? theme.colors.primary)
            .hkOptionalAccessibilityLabel(accessibilityLabel)
    }

    @ViewBuilder private var symbol: some View {
        if let renderingMode {
            Image(systemName: name).symbolRenderingMode(renderingMode)
        } else {
            Image(systemName: name)
        }
    }

    private var points: CGFloat {
        switch size {
        case .sm: theme.controls.smallIcon
        case .md: theme.controls.mediumIcon
        case .lg: theme.controls.largeIcon
        }
    }
}

#Preview("Icon sizes and meaning") {
    HKComponentPreview {
        HStack {
            HKIcon("star.fill", size: .sm)
            HKIcon("star.fill")
            HKIcon("star.fill", size: .lg, accessibilityLabel: Text("Favorite"))
        }
    }
}
