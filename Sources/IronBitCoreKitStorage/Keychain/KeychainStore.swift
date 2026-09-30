import Foundation
import Security

/// A keychain backed secure data store.
public final class KeychainStore: @unchecked Sendable {
    /// Creates a keychain store.
    public init() {}

    /// Reads data for an item.
    /// - Parameter item: The item descriptor.
    /// - Returns: The stored data when present.
    public func data(for item: KeychainItem) throws -> Data? {
        var query = baseQuery(for: item)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = true

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess else {
            throw StorageError.operationFailed("Keychain read failed with status \(status).")
        }

        return result as? Data
    }

    /// Stores data for an item.
    /// - Parameters:
    ///   - data: The data to store.
    ///   - item: The item descriptor.
    public func setData(_ data: Data, for item: KeychainItem) throws {
        var query = baseQuery(for: item)
        query[kSecAttrAccessible as String] = item.accessibility.secValue

        let attributes = [kSecValueData as String: data]
        let updateStatus = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

        if updateStatus == errSecSuccess {
            return
        }

        guard updateStatus == errSecItemNotFound else {
            throw StorageError.operationFailed("Keychain update failed with status \(updateStatus).")
        }

        query[kSecValueData as String] = data
        let addStatus = SecItemAdd(query as CFDictionary, nil)

        guard addStatus == errSecSuccess else {
            throw StorageError.operationFailed("Keychain add failed with status \(addStatus).")
        }
    }

    /// Removes data for an item.
    /// - Parameter item: The item descriptor.
    public func removeData(for item: KeychainItem) throws {
        let status = SecItemDelete(baseQuery(for: item) as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw StorageError.operationFailed("Keychain delete failed with status \(status).")
        }
    }

    private func baseQuery(for item: KeychainItem) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: item.service,
            kSecAttrAccount as String: item.account
        ]
    }
}
