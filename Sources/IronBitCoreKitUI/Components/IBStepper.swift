import SwiftUI

/// A themed numeric stepper.
public struct IBStepper<Value: Strideable>: View where Value.Stride: SignedNumeric {
    /// Stepper variants.
    public enum Variant: Sendable {
        /// Full label layout.
        case standard
        /// Compact label layout.
        case compact
    }

    @Environment(\.ironBitTheme) private var theme
    private let title: String
    @Binding private var value: Value
    private let range: ClosedRange<Value>
    private let step: Value.Stride
    private let variant: Variant

    /// Creates a stepper.
    public init(_ title: String, value: Binding<Value>, in range: ClosedRange<Value>, step: Value.Stride = 1, variant: Variant = .standard) {
        self.title = title
        self._value = value
        self.range = range
        self.step = step
        self.variant = variant
    }

    /// The stepper body.
    public var body: some View {
        Stepper(value: $value, in: range, step: step) {
            Text(title)
                .font(variant == .compact ? theme.typography.caption : theme.typography.body)
        }
        .tint(theme.colors.primary)
    }
}

#Preview {
    @Previewable @State var value = 2
    return IBStepper("Số lượng: \(value)", value: $value, in: 0...10)
        .padding()
}
