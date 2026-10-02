import SwiftUI

/// Common animation curves.
public enum HKAnimationCurves {
    /// Snappy interaction animation.
    public static let snappy = Animation.spring(response: 0.28, dampingFraction: 0.82)
    /// Gentle presentation animation.
    public static let gentle = Animation.easeInOut(duration: 0.32)
    /// Fast dismissal animation.
    public static let dismiss = Animation.easeOut(duration: 0.18)
}
