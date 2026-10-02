import SwiftUI

/// A scroll container with pull-to-refresh.
public struct HKRefreshControl<Content: View>: View {
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
    HKRefreshControl {} content: {
        Text("Kéo để làm mới").padding()
    }
}
