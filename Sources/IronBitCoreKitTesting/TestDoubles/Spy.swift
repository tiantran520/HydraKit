import Foundation

/// A generic spy that records values passed to it.
public final class Spy<Value> {
    private let lock = NSLock()
    private var storage: [Value] = []

    /// Creates an empty spy.
    public init() {}

    /// All captured values.
    public var values: [Value] {
        lock.withLock { storage }
    }

    /// The number of captured values.
    public var callCount: Int {
        lock.withLock { storage.count }
    }

    /// The most recent captured value.
    public var lastValue: Value? {
        lock.withLock { storage.last }
    }

    /// Records a value.
    /// - Parameter value: The value to capture.
    public func record(_ value: Value) {
        lock.withLock {
            storage.append(value)
        }
    }

    /// Clears all captured values.
    public func reset() {
        lock.withLock {
            storage.removeAll()
        }
    }
}
