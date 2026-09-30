import SwiftUI

public extension View {
    /// Applies a transform when a condition is true.
    @ViewBuilder
    func conditional<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
