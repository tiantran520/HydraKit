#if DEBUG
import Foundation

/// A selectable action displayed in the developer menu.
public struct DevMenuAction: Identifiable, Sendable {
    /// The action identifier.
    public let id: String

    /// The user-facing action title.
    public let title: String

    /// Optional supporting text for the action.
    public let subtitle: String?

    /// Whether the action should be displayed as destructive.
    public let isDestructive: Bool

    private let handler: @MainActor @Sendable () -> Void

    /// Creates a developer menu action.
    /// - Parameters:
    ///   - id: The action identifier.
    ///   - title: The user-facing action title.
    ///   - subtitle: Optional supporting text for the action.
    ///   - isDestructive: Whether the action should be displayed as destructive.
    ///   - handler: The closure executed when the action is selected.
    public init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String? = nil,
        isDestructive: Bool = false,
        handler: @escaping @MainActor @Sendable () -> Void
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.isDestructive = isDestructive
        self.handler = handler
    }

    /// Executes the action.
    @MainActor
    public func perform() {
        handler()
    }
}
#endif
