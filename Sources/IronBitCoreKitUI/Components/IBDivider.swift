import SwiftUI

/// A themed divider.
public struct IBDivider: View {
    /// Divider orientation.
    public enum Orientation: Sendable {
        /// Horizontal divider.
        case horizontal
        /// Vertical divider.
        case vertical
    }

    @Environment(\.ironBitTheme) private var theme
    private let orientation: Orientation

    /// Creates a divider.
    public init(_ orientation: Orientation = .horizontal) {
        self.orientation = orientation
    }

    /// The divider body.
    public var body: some View {
        Rectangle()
            .fill(theme.colors.border)
            .frame(
                width: orientation == .vertical ? 1 : nil,
                height: orientation == .horizontal ? 1 : nil
            )
    }
}

#Preview {
    VStack {
        Text("Top")
        IBDivider()
        Text("Bottom")
    }
    .padding()
}
