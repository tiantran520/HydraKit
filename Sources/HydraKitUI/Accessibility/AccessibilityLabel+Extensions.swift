import SwiftUI

public extension View {
    /// Applies an accessibility label from a plain string.
    func accessibilityLabel(_ label: String) -> some View {
        accessibilityLabel(Text(label))
    }

    /// Applies an accessibility hint from a plain string.
    func accessibilityHint(_ hint: String) -> some View {
        accessibilityHint(Text(hint))
    }
}

// An absent component override must preserve labels supplied by the image or an outer modifier.
extension View {
    @ViewBuilder
    func hkOptionalAccessibilityHint(_ hint: Text?) -> some View {
        if let hint { accessibilityHint(hint) } else { self }
    }

    @ViewBuilder
    func hkOptionalAccessibilityValue(_ value: Text?) -> some View {
        if let value { accessibilityValue(value) } else { self }
    }

    @ViewBuilder
    func hkOptionalAccessibilityLabel(_ label: Text?) -> some View {
        if let label {
            accessibilityLabel(label)
        } else {
            self
        }
    }
}
