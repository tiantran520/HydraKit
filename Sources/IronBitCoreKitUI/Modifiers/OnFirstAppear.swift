import SwiftUI

private struct OnFirstAppearModifier: ViewModifier {
    @State private var hasAppeared = false
    private let action: @MainActor () -> Void

    init(action: @escaping @MainActor () -> Void) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}

public extension View {
    /// Runs an action only the first time the view appears.
    func onFirstAppear(perform action: @escaping @MainActor () -> Void) -> some View {
        modifier(OnFirstAppearModifier(action: action))
    }
}
