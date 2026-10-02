import SwiftUI

/// A value that can create a SwiftUI binding from closures.
public struct TwoWayBinding<Value> {
    private let getter: () -> Value
    private let setter: (Value) -> Void

    /// Creates a two-way binding wrapper.
    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        self.getter = get
        self.setter = set
    }

    /// Converts this wrapper to a SwiftUI binding.
    public var binding: Binding<Value> {
        Binding(get: getter, set: setter)
    }
}
