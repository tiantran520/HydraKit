import SwiftUI

public extension AnyTransition {
    /// A default fade and scale transition.
    static var hkFadeScale: AnyTransition {
        .opacity.combined(with: .scale(scale: 0.96))
    }

    /// A default bottom slide transition.
    static var hkSlideUp: AnyTransition {
        .move(edge: .bottom).combined(with: .opacity)
    }
}
