import Foundation

/// A weak reference wrapper for class instances.
public final class HKWeak<Value: AnyObject> {
    /// The weakly held value.
    public weak var value: Value?

    /// Creates a weak reference wrapper.
    /// - Parameter value: The value to hold weakly.
    public init(_ value: Value?) {
        self.value = value
    }
}
