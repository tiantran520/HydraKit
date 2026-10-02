import Foundation

/// A configurable stub that returns a predefined result.
public final class HKStub<Input, Output> {
    private let lock = NSLock()
    private var handler: (Input) throws -> Output

    /// Creates a stub with a handler.
    /// - Parameter handler: The closure used to produce output.
    public init(_ handler: @escaping (Input) throws -> Output) {
        self.handler = handler
    }

    /// Replaces the stub handler.
    /// - Parameter handler: The new handler.
    public func update(_ handler: @escaping (Input) throws -> Output) {
        lock.withLock {
            self.handler = handler
        }
    }

    /// Produces an output for an input.
    /// - Parameter input: The input passed to the stub.
    /// - Returns: The configured output.
    public func callAsFunction(_ input: Input) throws -> Output {
        let current = lock.withLock { handler }
        return try current(input)
    }
}

/// A configurable stub that ignores input and returns a predefined result.
public final class HKVoidStub<Output> {
    private let lock = NSLock()
    private var handler: () throws -> Output

    /// Creates a stub with a handler.
    /// - Parameter handler: The closure used to produce output.
    public init(_ handler: @escaping () throws -> Output) {
        self.handler = handler
    }

    /// Replaces the stub handler.
    /// - Parameter handler: The new handler.
    public func update(_ handler: @escaping () throws -> Output) {
        lock.withLock {
            self.handler = handler
        }
    }

    /// Produces the configured output.
    /// - Returns: The configured output.
    public func callAsFunction() throws -> Output {
        let current = lock.withLock { handler }
        return try current()
    }
}
