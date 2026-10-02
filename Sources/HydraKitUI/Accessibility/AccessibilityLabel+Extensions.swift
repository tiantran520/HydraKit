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
