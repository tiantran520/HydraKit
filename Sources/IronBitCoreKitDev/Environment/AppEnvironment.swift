#if DEBUG
import Foundation

/// The runtime environment used by a debug build.
public enum AppEnvironment: String, CaseIterable, Identifiable, Sendable {
    /// Local development services.
    case dev

    /// Staging services.
    case staging

    /// Production services.
    case prod

    /// The stable identifier.
    public var id: String {
        rawValue
    }

    /// A display name suitable for debug UI.
    public var displayName: String {
        switch self {
        case .dev:
            "Development"
        case .staging:
            "Staging"
        case .prod:
            "Production"
        }
    }
}
#endif
