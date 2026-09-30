import SwiftUI

/// A themed avatar that displays initials or an image.
public struct IBAvatar: View {
    /// Avatar sizes.
    public enum Size: CGFloat, Sendable {
        /// Small avatar.
        case sm = 32
        /// Medium avatar.
        case md = 44
        /// Large avatar.
        case lg = 64
    }

    @Environment(\.ironBitTheme) private var theme
    private let initials: String
    private let image: Image?
    private let size: Size

    /// Creates an avatar.
    public init(initials: String, image: Image? = nil, size: Size = .md) {
        self.initials = initials
        self.image = image
        self.size = size
    }

    /// The avatar body.
    public var body: some View {
        ZStack {
            Circle().fill(theme.colors.primary.opacity(0.16))
            if let image {
                image.resizable().scaledToFill()
            } else {
                Text(initials)
                    .font(theme.typography.headline)
                    .foregroundStyle(theme.colors.primary)
            }
        }
        .frame(width: size.rawValue, height: size.rawValue)
        .clipShape(Circle())
    }
}

#Preview {
    HStack {
        IBAvatar(initials: "IB", size: .sm)
        IBAvatar(initials: "IB")
        IBAvatar(initials: "IB", size: .lg)
    }
    .padding()
}
