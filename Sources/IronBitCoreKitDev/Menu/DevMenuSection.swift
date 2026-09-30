#if DEBUG
import Foundation

/// A grouped section of developer menu actions.
public struct DevMenuSection: Identifiable, Sendable {
    /// The section identifier.
    public let id: String

    /// The section title.
    public let title: String

    /// The actions displayed in the section.
    public let actions: [DevMenuAction]

    /// Creates a developer menu section.
    /// - Parameters:
    ///   - id: The section identifier.
    ///   - title: The section title.
    ///   - actions: The actions displayed in the section.
    public init(
        id: String = UUID().uuidString,
        title: String,
        actions: [DevMenuAction]
    ) {
        self.id = id
        self.title = title
        self.actions = actions
    }
}
#endif
