#if DEBUG
import Foundation

/// Stores and changes the active debug app environment.
public final class EnvironmentSwitcher: ObservableObject {
    /// The user defaults key used to persist the selected environment.
    public let storageKey: String

    private let userDefaults: UserDefaults

    /// The currently selected environment.
    @Published public private(set) var current: AppEnvironment

    /// Creates an environment switcher.
    /// - Parameters:
    ///   - initialEnvironment: The environment used when no persisted value exists.
    ///   - userDefaults: The user defaults store.
    ///   - storageKey: The persistence key.
    public init(
        initialEnvironment: AppEnvironment = .dev,
        userDefaults: UserDefaults = .standard,
        storageKey: String = "IronBitCoreKitDev.AppEnvironment"
    ) {
        self.userDefaults = userDefaults
        self.storageKey = storageKey

        if let rawValue = userDefaults.string(forKey: storageKey),
           let environment = AppEnvironment(rawValue: rawValue) {
            self.current = environment
        } else {
            self.current = initialEnvironment
        }
    }

    /// Changes and persists the active environment.
    /// - Parameter environment: The environment to activate.
    public func switchTo(_ environment: AppEnvironment) {
        current = environment
        userDefaults.set(environment.rawValue, forKey: storageKey)
    }

    /// Resets the active environment to a value and clears persisted storage.
    /// - Parameter environment: The environment to restore.
    public func reset(to environment: AppEnvironment = .dev) {
        current = environment
        userDefaults.removeObject(forKey: storageKey)
    }
}
#endif
