import SwiftUI

/// A themed async image view.
public struct HKAsyncImage<Placeholder: View, Failure: View>: View {
    private let url: URL?
    private let placeholder: Placeholder
    private let failure: Failure

    /// Creates an async image.
    public init(
        url: URL?,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder failure: () -> Failure
    ) {
        self.url = url
        self.placeholder = placeholder()
        self.failure = failure()
    }

    /// The async image body.
    public var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case let .success(image):
                image.resizable().scaledToFill()
            case .failure:
                failure
            default:
                placeholder
            }
        }
    }
}

public extension HKAsyncImage where Placeholder == SkeletonView, Failure == Image {
    /// Creates an async image with default placeholder and failure icon.
    init(url: URL?) {
        self.init(url: url) {
            SkeletonView(.card)
        } failure: {
            Image(systemName: "photo")
        }
    }
}

#Preview {
    HKAsyncImage(url: URL(string: "https://example.com/image.png"))
        .frame(width: 160, height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding()
}
