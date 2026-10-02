import Foundation

/// A `UserDefaults` backed key-value store.
public final class HKUserDefaultsStore: KeyValueStore, @unchecked Sendable {
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    /// Creates a user defaults store.
    /// - Parameters:
    ///   - userDefaults: The user defaults instance.
    ///   - encoder: The encoder used for codable values.
    ///   - decoder: The decoder used for codable values.
    public init(
        userDefaults: UserDefaults = .standard,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }

    /// Reads a value for a key.
    public func value<Value: Codable & Sendable>(for key: StorageKey<Value>) async throws -> Value? {
        guard let data = userDefaults.data(forKey: key.rawValue) else {
            return nil
        }

        do {
            return try decoder.decode(Value.self, from: data)
        } catch {
            throw HKStorageError.decodingFailed(error.localizedDescription)
        }
    }

    /// Stores or removes a value for a key.
    public func setValue<Value: Codable & Sendable>(_ value: Value?, for key: StorageKey<Value>) async throws {
        guard let value else {
            userDefaults.removeObject(forKey: key.rawValue)
            return
        }

        do {
            userDefaults.set(try encoder.encode(value), forKey: key.rawValue)
        } catch {
            throw HKStorageError.encodingFailed(error.localizedDescription)
        }
    }

    /// Removes a value for a key.
    public func removeValue<Value>(for key: StorageKey<Value>) async throws {
        userDefaults.removeObject(forKey: key.rawValue)
    }

    /// Returns whether a raw key exists.
    public func contains(_ key: String) async -> Bool {
        userDefaults.object(forKey: key) != nil
    }

    /// Removes values from the current persistent domain when available.
    public func removeAll() async throws {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            throw HKStorageError.operationFailed("Không tìm thấy bundle identifier.")
        }
        userDefaults.removePersistentDomain(forName: bundleIdentifier)
    }
}
