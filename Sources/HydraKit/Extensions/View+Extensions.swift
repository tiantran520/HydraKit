#if canImport(SwiftUI)
import SwiftUI

/// Convenience helpers for SwiftUI views.
public extension View {
    /// Applies a transform only when a condition is true.
    /// - Parameters:
    ///   - condition: A Boolean value controlling whether the transform is applied.
    ///   - transform: The transform to apply.
    /// - Returns: Either the transformed view or the original view.
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Sets the view opacity to zero when hidden while preserving layout.
    /// - Parameter isHidden: A Boolean value indicating whether the view is hidden.
    /// - Returns: A view with adjusted opacity.
    func hidden(_ isHidden: Bool) -> some View {
        opacity(isHidden ? 0 : 1)
    }
}
#endif
