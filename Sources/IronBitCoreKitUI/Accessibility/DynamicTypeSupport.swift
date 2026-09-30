import SwiftUI

/// Helpers for Dynamic Type support.
public enum DynamicTypeSupport {
    /// Recommended minimum scale for compact controls.
    public static let compactMinimumScaleFactor: CGFloat = 0.85
    /// Recommended minimum scale for prominent headings.
    public static let headingMinimumScaleFactor: CGFloat = 0.75
}

public extension View {
    /// Applies a dynamic type friendly line policy.
    func dynamicTypeFriendly(lineLimit: Int? = nil, minimumScaleFactor: CGFloat = DynamicTypeSupport.compactMinimumScaleFactor) -> some View {
        self
            .lineLimit(lineLimit)
            .minimumScaleFactor(minimumScaleFactor)
            .fixedSize(horizontal: false, vertical: true)
    }
}
