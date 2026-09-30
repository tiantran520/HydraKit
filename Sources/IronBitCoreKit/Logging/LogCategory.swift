import Foundation

/// A logical category used to group log messages.
public struct LogCategory: RawRepresentable, Equatable, Hashable, Sendable {
    /// The raw category name.
    public let rawValue: String

    /// Creates a category with a raw name.
    /// - Parameter rawValue: The raw category name.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension LogCategory {
    /// Logs related to general application behavior.
    static let general = LogCategory(rawValue: "general")

    /// Logs related to networking.
    static let network = LogCategory(rawValue: "network")

    /// Logs related to persistence.
    static let storage = LogCategory(rawValue: "storage")

    /// Logs related to user interface behavior.
    static let ui = LogCategory(rawValue: "ui")
}
