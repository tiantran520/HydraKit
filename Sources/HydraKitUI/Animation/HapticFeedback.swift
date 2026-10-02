import Foundation

#if canImport(UIKit) && !os(tvOS)
import UIKit
#endif

/// Cross-platform haptic feedback helper.
public enum HKHapticFeedback {
    /// Haptic styles.
    public enum HKStyle: Sendable {
        /// Light feedback.
        case light
        /// Medium feedback.
        case medium
        /// Heavy feedback.
        case heavy
        /// Success notification feedback.
        case success
        /// Warning notification feedback.
        case warning
        /// Error notification feedback.
        case error
    }

    /// Triggers haptic feedback when the platform supports it.
    @MainActor
    public static func trigger(_ style: HKStyle = .light) {
        #if canImport(UIKit) && !os(tvOS)
        switch style {
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
        #endif
    }
}
