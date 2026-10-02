import SwiftUI

/// A themed slider.
public struct HKSlider: View {
    @Environment(\.ironBitTheme) private var theme
    @Binding private var value: Double
    private let range: ClosedRange<Double>

    /// Creates a slider.
    public init(value: Binding<Double>, in range: ClosedRange<Double> = 0...1) {
        self._value = value
        self.range = range
    }

    /// The slider body.
    public var body: some View {
        Slider(value: $value, in: range)
            .tint(theme.colors.primary)
    }
}

#Preview {
    @Previewable @State var value = 0.4
    return HKSlider(value: $value).padding()
}
