import SwiftUI

/// A themed system icon.
public struct IBIcon: View {
    /// Icon sizes.
    public enum Size: CGFloat, Sendable {
        /// Small icon.
        case sm = 16
        /// Medium icon.
        case md = 22
        /// Large icon.
        case lg = 32
    }

    @Environment(\.ironBitTheme) private var theme
    private let name: String
    private let size: Size

    /// Creates an icon.
    public init(_ name: String, size: Size = .md) {
        self.name = name
        self.size = size
    }

    /// The icon body.
    public var body: some View {
        Image(systemName: name)
            .font(.system(size: size.rawValue, weight: .semibold))
            .foregroundStyle(theme.colors.primary)
    }
}

#Preview {
    HStack {
        IBIcon("star.fill", size: .sm)
        IBIcon("star.fill")
        IBIcon("star.fill", size: .lg)
    }
    .padding()
}
