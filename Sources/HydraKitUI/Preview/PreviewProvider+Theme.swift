import SwiftUI

public extension View {
    /// Applies common preview defaults for IronBit UI.
    func ironBitPreview(theme: any Theme = DefaultTheme()) -> some View {
        self
            .ironBitTheme(theme)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
