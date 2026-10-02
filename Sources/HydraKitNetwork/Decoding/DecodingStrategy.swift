import Foundation

/// A reusable JSON decoding strategy for API responses.
public struct DecodingStrategy: Sendable {
    /// The date decoding strategy.
    public let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy

    /// The key decoding strategy.
    public let keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy

    /// The data decoding strategy.
    public let dataDecodingStrategy: JSONDecoder.DataDecodingStrategy

    /// Creates a decoding strategy.
    /// - Parameters:
    ///   - dateDecodingStrategy: The date decoding strategy.
    ///   - keyDecodingStrategy: The key decoding strategy.
    ///   - dataDecodingStrategy: The data decoding strategy.
    public init(
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64
    ) {
        self.dateDecodingStrategy = dateDecodingStrategy
        self.keyDecodingStrategy = keyDecodingStrategy
        self.dataDecodingStrategy = dataDecodingStrategy
    }

    /// Applies the strategy to a decoder.
    /// - Parameter decoder: The decoder to configure.
    public func apply(to decoder: JSONDecoder) {
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dataDecodingStrategy = dataDecodingStrategy
    }
}

public extension DecodingStrategy {
    /// A default API strategy using ISO 8601 dates and default keys.
    static let `default` = DecodingStrategy()

    /// A strategy for APIs that return snake_case keys.
    static let snakeCase = DecodingStrategy(keyDecodingStrategy: .convertFromSnakeCase)
}
