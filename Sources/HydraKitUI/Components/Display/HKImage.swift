import SwiftUI

/// A themed image wrapper.
public struct HKImage: View {
    /// Image shape variants.
    public enum HKVariant: Sendable {
        /// Rectangular image.
        case rectangle
        /// Rounded image.
        case rounded
        /// Circular image.
        case circle
    }

    private let image: Image
    private let variant: HKVariant

    /// Creates an image wrapper.
    public init(_ image: Image, variant: HKVariant = .rounded) {
        self.image = image
        self.variant = variant
    }

    /// The image body.
    public var body: some View {
        image
            .resizable()
            .scaledToFill()
            .clipShape(shape)
    }

    private var shape: AnyShape {
        switch variant {
        case .rectangle: AnyShape(Rectangle())
        case .rounded: AnyShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        case .circle: AnyShape(Circle())
        }
    }
}

#Preview {
    HKImage(Image(systemName: "photo"), variant: .rounded)
        .frame(width: 80, height: 80)
        .padding()
}
