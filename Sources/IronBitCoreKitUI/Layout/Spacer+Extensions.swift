import SwiftUI

public extension Spacer {
    /// Creates a fixed-width spacer.
    static func width(_ value: CGFloat) -> some View {
        Spacer().frame(width: value)
    }

    /// Creates a fixed-height spacer.
    static func height(_ value: CGFloat) -> some View {
        Spacer().frame(height: value)
    }
}
