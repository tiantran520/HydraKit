import SwiftUI

/// Primary style for native SwiftUI Buttons, sharing HKButton interaction tokens.
public struct HKPrimaryButtonStyle: ButtonStyle {
    /// Creates the primary, medium button style.
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        HKComponentButtonStyle<Text>(variant: .primary, size: .md)
            .makeBody(configuration: configuration)
    }
}

public extension ButtonStyle where Self == HKPrimaryButtonStyle {
    /// Hydra primary button style.
    static var hkPrimary: HKPrimaryButtonStyle { HKPrimaryButtonStyle() }
}
