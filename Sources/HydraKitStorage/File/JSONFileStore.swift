import Foundation

/// A JSON file store for codable values.
public final class HKJSONFileStore: @unchecked Sendable {
    private let fileStore: HKFileStore
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    /// Creates a JSON file store.
    public init(
        fileStore: HKFileStore = HKFileStore(),
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.fileStore = fileStore
        self.encoder = encoder
        self.decoder = decoder
    }

    /// Reads a decodable value from a relative path.
    public func value<Value: Decodable>(_ type: Value.Type = Value.self, at path: String) throws -> Value {
        do {
            return try decoder.decode(Value.self, from: fileStore.data(at: path))
        } catch {
            throw HKStorageError.decodingFailed(error.localizedDescription)
        }
    }

    /// Writes an encodable value to a relative path.
    public func write<Value: Encodable>(_ value: Value, to path: String) throws {
        do {
            try fileStore.write(try encoder.encode(value), to: path)
        } catch let error as HKStorageError {
            throw error
        } catch {
            throw HKStorageError.encodingFailed(error.localizedDescription)
        }
    }

    /// Removes a JSON file at a relative path.
    public func remove(at path: String) throws {
        try fileStore.remove(at: path)
    }
}
