import Foundation

/// Reads remote configuration values.
public protocol RemoteConfigService: Sendable {
    /// Fetches the latest configuration.
    func fetch() async throws
    /// Returns a value for a key.
    func value(for key: String) async -> ConfigValue
}
