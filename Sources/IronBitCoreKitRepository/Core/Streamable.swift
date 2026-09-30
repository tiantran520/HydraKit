import Foundation

/// A repository capability for streaming model collections.
public protocol Streamable: Sendable {
    /// The streamed model type.
    associatedtype Model: Sendable

    /// Returns an asynchronous stream of model collections.
    /// - Returns: A stream of model snapshots.
    func stream() -> AsyncStream<[Model]>
}
