import SwiftUI

/// Helpers for right-to-left layout support.
public enum RTLSupport {
    /// Returns whether a layout direction is right-to-left.
    public static func isRTL(_ direction: LayoutDirection) -> Bool {
        direction == .rightToLeft
    }

    /// Returns the leading edge for the current layout direction.
    public static func leadingEdge(for direction: LayoutDirection) -> HorizontalEdge {
        direction == .rightToLeft ? .trailing : .leading
    }
}
