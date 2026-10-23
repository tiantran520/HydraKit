import Foundation

/// Shared interaction metrics. Heights are minimums so Dynamic Type can grow controls.
public struct ControlTokens: Sendable {
    /// Minimum interactive width and height.
    public let minimumTarget: CGFloat
    /// Minimum small button height.
    public let smallHeight: CGFloat
    /// Minimum medium button height.
    public let mediumHeight: CGFloat
    /// Minimum large button height.
    public let largeHeight: CGFloat
    /// Small symbol size, scaled by Dynamic Type.
    public let smallIcon: CGFloat
    /// Medium symbol size, scaled by Dynamic Type.
    public let mediumIcon: CGFloat
    /// Large symbol size, scaled by Dynamic Type.
    public let largeIcon: CGFloat
    /// Standard border thickness.
    public let borderWidth: CGFloat
    /// Focused border thickness.
    public let focusBorderWidth: CGFloat
    /// Opacity of disabled controls.
    public let disabledOpacity: Double
    /// Opacity of pressed buttons.
    public let pressedOpacity: Double

    /// Creates metrics; defaults use a 44-point minimum interaction target.
    public init(
        minimumTarget: CGFloat = 44, smallHeight: CGFloat = 44,
        mediumHeight: CGFloat = 44, largeHeight: CGFloat = 56,
        smallIcon: CGFloat = 16, mediumIcon: CGFloat = 22, largeIcon: CGFloat = 32,
        borderWidth: CGFloat = 1, focusBorderWidth: CGFloat = 2,
        disabledOpacity: Double = 0.5, pressedOpacity: Double = 0.82
    ) {
        self.minimumTarget = minimumTarget
        self.smallHeight = smallHeight
        self.mediumHeight = mediumHeight
        self.largeHeight = largeHeight
        self.smallIcon = smallIcon
        self.mediumIcon = mediumIcon
        self.largeIcon = largeIcon
        self.borderWidth = borderWidth
        self.focusBorderWidth = focusBorderWidth
        self.disabledOpacity = disabledOpacity
        self.pressedOpacity = pressedOpacity
    }
}
