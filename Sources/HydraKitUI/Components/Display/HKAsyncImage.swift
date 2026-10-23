import SwiftUI

/// Native AsyncImage with caller-provided loading and failure content. No live services are required by previews.
public struct HKAsyncImage<Placeholder: View, Failure: View>: View {
    private let url: URL?
    private let contentMode: ContentMode
    private let accessibilityLabel: Text?
    private let placeholder: Placeholder
    private let failure: Failure
    private var usesDefaultContent = false

    /// Defaults: fill and the native image accessibility. A nil URL keeps displaying the placeholder.
    /// Give loading/failure content its own accessibility labels when appropriate.
    /// Preserves the original placeholder/failure ViewBuilder initializer.
    public init(
        url: URL?,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder failure: () -> Failure
    ) {
        self.init(url: url, contentMode: .fill, placeholder: placeholder, failure: failure)
    }

    /// Creates an async image with optional scaling and accessibility overrides.
    public init(
        url: URL?, contentMode: ContentMode = .fill, accessibilityLabel: Text? = nil,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder failure: () -> Failure
    ) {
        self.url = url
        self.contentMode = contentMode
        self.accessibilityLabel = accessibilityLabel
        self.placeholder = placeholder()
        self.failure = failure()
    }

    public var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case let .success(image):
                image.resizable().aspectRatio(contentMode: contentMode)
                    .hkOptionalAccessibilityLabel(accessibilityLabel)
            case .failure: failureContent
            default:
                if usesDefaultContent { placeholder.accessibilityHidden(true) }
                else { placeholder }
            }
        }
    }

    @ViewBuilder private var failureContent: some View {
        if usesDefaultContent {
            failure.accessibilityLabel(Text("Image unavailable"))
        } else {
            failure
        }
    }
}

public extension HKAsyncImage where Placeholder == SkeletonView, Failure == Image {
    /// Preserves the original default-image initializer.
    init(url: URL?) {
        self.init(url: url, contentMode: .fill)
    }

    /// Creates a default skeleton and unavailable-photo symbol. Parent provides layout bounds.
    init(url: URL?, contentMode: ContentMode = .fill, accessibilityLabel: Text? = nil) {
        self.init(url: url, contentMode: contentMode, accessibilityLabel: accessibilityLabel) {
            SkeletonView(.card)
        } failure: {
            Image(systemName: "photo")
        }
        self.usesDefaultContent = true
    }
}

#Preview("Offline image placeholder") {
    HKComponentPreview {
        HKAsyncImage(url: nil)
            .frame(height: 100)
        HKAsyncImage(url: nil) {
            ProgressView()
        } failure: {
            Label("Image unavailable", systemImage: "photo")
        }
    }
}
