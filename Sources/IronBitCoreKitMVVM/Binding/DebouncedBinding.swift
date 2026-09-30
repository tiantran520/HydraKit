import SwiftUI

/// A debounced binding adapter.
@MainActor
public final class DebouncedBinding<Value>: ObservableObject {
    /// The immediate value.
    @Published public var value: Value {
        didSet {
            schedule(value)
        }
    }

    private let delay: Duration
    private let onDebouncedChange: @MainActor (Value) -> Void
    private var task: Task<Void, Never>?

    /// Creates a debounced binding adapter.
    public init(
        initialValue: Value,
        delay: Duration = .milliseconds(300),
        onDebouncedChange: @escaping @MainActor (Value) -> Void
    ) {
        self.value = initialValue
        self.delay = delay
        self.onDebouncedChange = onDebouncedChange
    }

    /// A SwiftUI binding for the immediate value.
    public var binding: Binding<Value> {
        Binding(
            get: { self.value },
            set: { self.value = $0 }
        )
    }

    private func schedule(_ value: Value) {
        task?.cancel()
        task = Task { @MainActor in
            try? await Task.sleep(for: delay)
            guard !Task.isCancelled else { return }
            onDebouncedChange(value)
        }
    }

    deinit {
        task?.cancel()
    }
}
