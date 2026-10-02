#if DEBUG
import Foundation

/// Provides mock data for debug screens, previews, and local development flows.
public final class HKMockDataProvider {
    private var factories: [String: () -> Any] = [:]
    private let lock = NSLock()

    /// Creates an empty mock data provider.
    public init() {}

    /// Registers a mock value factory for a key.
    /// - Parameters:
    ///   - key: The lookup key.
    ///   - factory: A closure that creates the mock value.
    public func register<Value>(
        _ key: String,
        factory: @escaping () -> Value
    ) {
        lock.withLock {
            factories[key] = factory
        }
    }

    /// Resolves a mock value for a key.
    /// - Parameters:
    ///   - type: The expected value type.
    ///   - key: The lookup key.
    /// - Returns: The mock value when one is registered with the expected type.
    public func value<Value>(
        _ type: Value.Type = Value.self,
        for key: String
    ) -> Value? {
        lock.withLock {
            factories[key]?() as? Value
        }
    }

    /// Removes all registered mock factories.
    public func reset() {
        lock.withLock {
            factories.removeAll()
        }
    }
}
#endif
