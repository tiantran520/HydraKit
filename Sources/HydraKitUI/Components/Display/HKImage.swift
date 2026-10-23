import SwiftUI

/// A resizable image. Supply a label for meaningful content; nil preserves native image semantics.
public struct HKImage: View {
    /// Clipping shapes for the image.
    public enum HKVariant: Sendable { case rectangle, rounded, circle }

    @Environment(\.ironBitTheme) private var theme
    private let image: Image
    private let variant: HKVariant
    private let contentMode: ContentMode
    private let renderingMode: Image.TemplateRenderingMode?
    private let accessibilityLabel: Text?

    /// Defaults: rounded, fill, original image rendering, native accessibility.
    /// The parent supplies layout bounds. Fill may crop; fit preserves the entire image.
    /// Preserves the original image initializer and the supplied Image accessibility.
    public init(_ image: Image, variant: HKVariant = .rounded) {
        self.init(image, variant: variant, contentMode: .fill)
    }

    /// Creates an image with optional scaling, rendering, and accessibility overrides.
    public init(
        _ image: Image, variant: HKVariant = .rounded,
        contentMode: ContentMode = .fill,
        renderingMode: Image.TemplateRenderingMode? = nil,
        accessibilityLabel: Text? = nil
    ) {
        self.image = image
        self.variant = variant
        self.contentMode = contentMode
        self.renderingMode = renderingMode
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        renderedImage
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .clipShape(shape)
            .hkOptionalAccessibilityLabel(accessibilityLabel)
    }

    private var renderedImage: Image {
        guard let renderingMode else { return image }
        return image.renderingMode(renderingMode)
    }

    private var shape: AnyShape {
        switch variant {
        case .rectangle: AnyShape(Rectangle())
        case .rounded: AnyShape(RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous))
        case .circle: AnyShape(Circle())
        }
    }
}

#Preview("Image shapes, fit and accessibility") {
    HKComponentPreview {
        HStack {
            HKImage(Image(systemName: "photo"), variant: .rectangle, contentMode: .fit)
            HKImage(Image(systemName: "photo"), accessibilityLabel: Text("Sample landscape"))
            HKImage(Image(systemName: "person.fill"), variant: .circle, contentMode: .fit)
        }
        .frame(height: 80)
    }
}
