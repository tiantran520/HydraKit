import Foundation

/// A case-insensitive collection of HTTP header fields.
public struct HTTPHeaders: Equatable, Sendable {
    private var storage: [String: String]

    /// Creates an empty header collection.
    public init() {
        self.storage = [:]
    }

    /// Creates a header collection from a dictionary.
    /// - Parameter headers: The header values keyed by field name.
    public init(_ headers: [String: String]) {
        self.storage = headers
    }

    /// Reads or writes a header value.
    /// - Parameter name: The header field name.
    public subscript(_ name: String) -> String? {
        get {
            storage[firstKey(matching: name) ?? name]
        }
        set {
            if let key = firstKey(matching: name) {
                storage[key] = newValue
            } else {
                storage[name] = newValue
            }
        }
    }

    /// The underlying dictionary representation.
    public var dictionary: [String: String] {
        storage
    }

    /// Adds all headers from another collection.
    /// - Parameter headers: The headers to merge into this collection.
    public mutating func merge(_ headers: HTTPHeaders) {
        headers.storage.forEach { self[$0.key] = $0.value }
    }

    private func firstKey(matching name: String) -> String? {
        storage.keys.first { $0.caseInsensitiveCompare(name) == .orderedSame }
    }
}

extension HTTPHeaders: ExpressibleByDictionaryLiteral {
    /// Creates a header collection from a dictionary literal.
    public init(dictionaryLiteral elements: (String, String)...) {
        self.init(Dictionary(uniqueKeysWithValues: elements))
    }
}

extension HTTPHeaders: Sequence {
    /// Creates an iterator over the header fields.
    public func makeIterator() -> Dictionary<String, String>.Iterator {
        storage.makeIterator()
    }
}

public extension HTTPHeaders {
    /// The `Accept` header field.
    static let accept = "Accept"

    /// The `Authorization` header field.
    static let authorization = "Authorization"

    /// The `Content-Type` header field.
    static let contentType = "Content-Type"

    /// A JSON content type value.
    static let applicationJSON = "application/json"
}
