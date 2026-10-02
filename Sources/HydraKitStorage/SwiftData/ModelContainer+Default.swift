import Foundation

#if canImport(SwiftData)
import SwiftData

/// Convenience factory methods for SwiftData model containers.
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, visionOS 1, *)
public extension ModelContainer {
    /// Creates a model container for the supplied schema.
    static func ironBitDefault(
        for schema: Schema,
        isStoredInMemoryOnly: Bool = false
    ) throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        return try ModelContainer(for: schema, configurations: [configuration])
    }
}
#endif
