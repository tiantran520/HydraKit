import SwiftUI

/// Animation tokens used for consistent motion.
public struct AnimationTokens: Sendable {
    /// Fast interaction animation.
    public let fast: Animation
    /// Standard interaction animation.
    public let standard: Animation
    /// Slow emphasis animation.
    public let slow: Animation

    /// Creates animation tokens.
    public init(
        fast: Animation = .easeOut(duration: 0.16),
        standard: Animation = .easeInOut(duration: 0.24),
        slow: Animation = .easeInOut(duration: 0.40)
    ) {
        self.fast = fast
        self.standard = standard
        self.slow = slow
    }
}
