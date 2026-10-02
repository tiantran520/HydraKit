import SwiftUI

/// A themed system icon.
public struct HKIcon: View {
    /// Icon sizes.
    public enum HKSize: CGFloat, Sendable {
        /// Small icon.
        case sm = 16
        /// Medium icon.
        case md = 22
        /// Large icon.
        case lg = 32
    }

    @Environment(\.ironBitTheme) private var theme
    private let name: String
    private let size: HKSize

    /// Creates an icon.
    public init(_ name: String, size: HKSize = .md) {
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
        HKIcon("star.fill", size: .sm)
        HKIcon("star.fill")
        HKIcon("star.fill", size: .lg)
    }
    .padding()
}
