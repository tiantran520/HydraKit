import SwiftUI

public extension AnyTransition {
    /// A default fade and scale transition.
    static var ibFadeScale: AnyTransition {
        .opacity.combined(with: .scale(scale: 0.96))
    }

    /// A default bottom slide transition.
    static var ibSlideUp: AnyTransition {
        .move(edge: .bottom).combined(with: .opacity)
    }
}
