import SwiftUI

/// A scroll container with pull-to-refresh.
public struct IBRefreshControl<Content: View>: View {
    private let action: @Sendable () async -> Void
    private let content: Content

    /// Creates a refresh control.
    public init(action: @escaping @Sendable () async -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }

    /// The refreshable body.
    public var body: some View {
        ScrollView {
            content
        }
        .refreshable {
            await action()
        }
    }
}

#Preview {
    IBRefreshControl {} content: {
        Text("Kéo để làm mới").padding()
    }
}
