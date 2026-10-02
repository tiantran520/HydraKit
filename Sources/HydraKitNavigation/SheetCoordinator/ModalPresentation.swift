import Foundation

/// Presentation styles for modal routes.
public enum HKModalPresentation: Sendable {
    /// Standard sheet presentation.
    case sheet
    /// Full-screen cover presentation.
    case fullScreen
    /// Popover presentation where supported.
    case popover
}
