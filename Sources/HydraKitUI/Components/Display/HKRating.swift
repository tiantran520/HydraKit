import SwiftUI

/// A simple star rating display.
public struct HKRating: View {
    @Environment(\.ironBitTheme) private var theme
    private let value: Double
    private let maximum: Int

    /// Creates a rating view.
    public init(value: Double, maximum: Int = 5) {
        self.value = value
        self.maximum = maximum
    }

    /// The rating body.
    public var body: some View {
        HStack(spacing: theme.spacing.xs) {
            ForEach(1...maximum, id: \.self) { index in
                Image(systemName: Double(index) <= value.rounded(.down) ? "star.fill" : "star")
                    .foregroundStyle(theme.colors.warning)
            }
        }
        .accessibilityLabel("Rating \(value) of \(maximum)")
    }
}

#Preview {
    HKRating(value: 4).padding()
}
