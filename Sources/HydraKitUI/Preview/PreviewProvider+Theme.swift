import SwiftUI

public extension View {
    /// Applies common preview defaults for Hydra UI.
    func hydraKitPreview(theme: any Theme = DefaultTheme()) -> some View {
        self
            .hydraKitTheme(theme)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
