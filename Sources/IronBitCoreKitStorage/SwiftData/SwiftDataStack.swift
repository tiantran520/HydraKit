import Foundation

#if canImport(SwiftData)
import SwiftData

/// A lightweight SwiftData stack.
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, visionOS 1, *)
public final class SwiftDataStack: @unchecked Sendable {
    /// The SwiftData model container.
    public let container: ModelContainer

    /// The main model context.
    @MainActor public var mainContext: ModelContext {
        container.mainContext
    }

    /// Creates a SwiftData stack.
    public init(container: ModelContainer) {
        self.container = container
    }

    /// Creates a new model context.
    public func makeContext() -> ModelContext {
        ModelContext(container)
    }
}
#endif
