import Foundation

/// A type-erased `Codable` value for dynamic JSON payloads.
public struct AnyCodable: Codable, Equatable {
    /// The wrapped value.
    public let value: Any?

    /// Creates a type-erased codable value.
    /// - Parameter value: The value to wrap.
    public init(_ value: Any?) {
        self.value = value
    }

    /// Decodes a dynamic JSON value.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            value = nil
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map(\.value)
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            value = dictionary.mapValues(\.value)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unsupported JSON value."
            )
        }
    }

    /// Encodes a dynamic JSON value.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case nil:
            try container.encodeNil()
        case let value as Bool:
            try container.encode(value)
        case let value as Int:
            try container.encode(value)
        case let value as Double:
            try container.encode(value)
        case let value as Float:
            try container.encode(Double(value))
        case let value as String:
            try container.encode(value)
        case let value as [Any?]:
            try container.encode(value.map(AnyCodable.init))
        case let value as [AnyCodable]:
            try container.encode(value)
        case let value as [String: Any?]:
            try container.encode(value.mapValues(AnyCodable.init))
        case let value as [String: AnyCodable]:
            try container.encode(value)
        default:
            let context = EncodingError.Context(
                codingPath: encoder.codingPath,
                debugDescription: "Unsupported JSON value: \(String(describing: value))"
            )
            throw EncodingError.invalidValue(value as Any, context)
        }
    }

    /// Compares two type-erased codable values.
    public static func == (lhs: AnyCodable, rhs: AnyCodable) -> Bool {
        switch (lhs.value, rhs.value) {
        case (nil, nil):
            true
        case let (lhs as Bool, rhs as Bool):
            lhs == rhs
        case let (lhs as Int, rhs as Int):
            lhs == rhs
        case let (lhs as Double, rhs as Double):
            lhs == rhs
        case let (lhs as String, rhs as String):
            lhs == rhs
        case let (lhs as [Any?], rhs as [Any?]):
            lhs.map(AnyCodable.init) == rhs.map(AnyCodable.init)
        case let (lhs as [String: Any?], rhs as [String: Any?]):
            lhs.mapValues(AnyCodable.init) == rhs.mapValues(AnyCodable.init)
        default:
            false
        }
    }
}
