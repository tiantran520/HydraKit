import Foundation

public extension JSONDecoder {
    /// Creates a JSON decoder configured for IronBitCoreKit network responses.
    /// - Parameter strategy: The strategy used to configure the decoder.
    /// - Returns: A configured JSON decoder.
    static func ironBitDefault(strategy: DecodingStrategy = .default) -> JSONDecoder {
        let decoder = JSONDecoder()
        strategy.apply(to: decoder)
        return decoder
    }
}
