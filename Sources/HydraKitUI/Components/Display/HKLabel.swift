import SwiftUI

/// A themed label with a system icon.
public struct HKLabel: View {
    @Environment(\.ironBitTheme) private var theme
    private let title: String
    private let systemImage: String

    /// Creates a label.
    public init(_ title: String, systemImage: String) {
        self.title = title
        self.systemImage = systemImage
    }

    /// The label body.
    public var body: some View {
        Label(title, systemImage: systemImage)
            .font(theme.typography.body)
            .foregroundStyle(theme.colors.textPrimary)
    }
}

#Preview {
    HKLabel("Hồ sơ", systemImage: "person.crop.circle").padding()
}
