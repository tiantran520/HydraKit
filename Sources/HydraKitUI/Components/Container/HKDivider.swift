import SwiftUI

/// A themed divider.
public struct HKDivider: View {
    /// Divider orientation.
    public enum HKOrientation: Sendable {
        /// Horizontal divider.
        case horizontal
        /// Vertical divider.
        case vertical
    }

    @Environment(\.ironBitTheme) private var theme
    private let orientation: HKOrientation

    /// Creates a divider.
    public init(_ orientation: HKOrientation = .horizontal) {
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
        HKDivider()
        Text("Bottom")
    }
    .padding()
}
