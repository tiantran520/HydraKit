import SwiftUI

/// Alert presentation state.
public struct IBAlertState: Identifiable, Sendable {
    /// Alert identifier.
    public let id = UUID()
    /// Alert title.
    public var title: String
    /// Alert message.
    public var message: String?

    /// Creates an alert state.
    public init(title: String, message: String? = nil) {
        self.title = title
        self.message = message
    }
}

public extension View {
    /// Presents a simple Hydra alert.
    func ibAlert(_ state: Binding<IBAlertState?>) -> some View {
        alert(item: state) { alert in
            Alert(
                title: Text(alert.title),
                message: alert.message.map(Text.init),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
