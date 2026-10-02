import SwiftUI

public extension Binding {
    /// Creates a binding by mapping the current value into another value.
    func map<Mapped>(
        get: @escaping (Value) -> Mapped,
        set: @escaping (Mapped, inout Value) -> Void
    ) -> Binding<Mapped> {
        Binding<Mapped>(
            get: { get(wrappedValue) },
            set: { newValue in
                var value = wrappedValue
                set(newValue, &value)
                wrappedValue = value
            }
        )
    }

    /// Runs a closure whenever the binding value changes.
    func onChange(_ action: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { newValue in
                wrappedValue = newValue
                action(newValue)
            }
        )
    }
}

public extension Binding where Value == Bool {
    /// Returns a binding with the boolean value inverted.
    var inverted: Binding<Bool> {
        Binding(
            get: { !wrappedValue },
            set: { wrappedValue = !$0 }
        )
    }
}
