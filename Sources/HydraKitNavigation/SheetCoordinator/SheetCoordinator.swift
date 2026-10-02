import Foundation
import SwiftUI

/// Coordinates modal route presentation.
@MainActor
public final class HKSheetCoordinator: ObservableObject {
    /// The currently presented route.
    @Published public private(set) var route: AnyRoute?
    /// The current presentation style.
    @Published public private(set) var presentation: HKModalPresentation = .sheet

    /// Creates a sheet coordinator.
    public init() {}

    /// Presents a route.
    public func present<R: Route>(_ route: R, presentation: HKModalPresentation = .sheet) {
        self.route = AnyRoute(route)
        self.presentation = presentation
    }

    /// Dismisses the current route.
    public func dismiss() {
        route = nil
    }
}
