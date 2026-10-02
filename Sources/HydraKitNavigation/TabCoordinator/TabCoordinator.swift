import Foundation
import SwiftUI

/// Coordinates selection across a group of tab routes.
@MainActor
public final class HKTabCoordinator<Tab: TabRoute>: ObservableObject {
    /// Available tabs.
    public let tabs: [Tab]
    /// Currently selected tab.
    @Published public var selection: Tab

    /// Creates a tab coordinator.
    public init(tabs: [Tab], selection: Tab? = nil) {
        precondition(!tabs.isEmpty, "HKTabCoordinator requires at least one tab.")
        self.tabs = tabs
        self.selection = selection ?? tabs[0]
    }

    /// Selects a tab.
    public func select(_ tab: Tab) {
        guard tabs.contains(tab) else { return }
        selection = tab
    }
}
