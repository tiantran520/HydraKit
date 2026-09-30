import Foundation
import SwiftUI

/// Coordinates modal route presentation.
@MainActor
public final class SheetCoordinator: ObservableObject {
    /// The currently presented route.
    @Published public private(set) var route: AnyRoute?
    /// The current presentation style.
    @Published public private(set) var presentation: ModalPresentation = .sheet

    /// Creates a sheet coordinator.
    public init() {}

    /// Presents a route.
    public func present<R: Route>(_ route: R, presentation: ModalPresentation = .sheet) {
        self.route = AnyRoute(route)
        self.presentation = presentation
    }

    /// Dismisses the current route.
    public func dismiss() {
        route = nil
    }
}
