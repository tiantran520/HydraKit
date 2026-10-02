import Foundation

/// A route that can be selected in a tab coordinator.
public protocol TabRoute: Route {
    /// The display title for the tab.
    var title: String { get }
    /// The SF Symbol name for the tab.
    var systemImage: String { get }
}
