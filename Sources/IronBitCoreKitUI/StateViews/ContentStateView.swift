import SwiftUI

/// Generic content loading states.
public enum ContentState<Value: Sendable>: Sendable {
    /// Data is loading.
    case loading
    /// No data is available.
    case empty
    /// Loading failed.
    case error(String?)
    /// Data is ready.
    case content(Value)
}

/// A view that switches between loading, empty, error and content states.
public struct ContentStateView<Value: Sendable, Content: View>: View {
    private let state: ContentState<Value>
    private let retry: (@MainActor () -> Void)?
    private let content: (Value) -> Content

    /// Creates a content state view.
    public init(
        state: ContentState<Value>,
        retry: (@MainActor () -> Void)? = nil,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.state = state
        self.retry = retry
        self.content = content
    }

    /// The switched body.
    public var body: some View {
        switch state {
        case .loading:
            LoadingView()
        case .empty:
            EmptyStateView()
        case let .error(message):
            if let retry {
                RetryView(message: message, retry: retry)
            } else {
                ErrorStateView(message: message)
            }
        case let .content(value):
            content(value)
        }
    }
}

#Preview {
    ContentStateView(state: ContentState<[String]>.content(["A", "B"])) { values in
        List(values, id: \.self) { Text($0) }
    }
}
