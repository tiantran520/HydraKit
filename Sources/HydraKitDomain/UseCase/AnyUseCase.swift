import Foundation

/// A type-erased use case.
public struct AnyUseCase<Input: Sendable, Output: Sendable>: UseCase {
    private let operation: @Sendable (Input) async throws -> Output

    /// Creates a type-erased use case.
    /// - Parameter operation: The operation to execute.
    public init(operation: @escaping @Sendable (Input) async throws -> Output) {
        self.operation = operation
    }

    /// Creates a type-erased wrapper around a concrete use case.
    /// - Parameter useCase: The concrete use case to wrap.
    public init<U: UseCase>(_ useCase: U) where U.Input == Input, U.Output == Output {
        self.operation = { input in
            try await useCase.execute(input)
        }
    }

    /// Executes the wrapped use case.
    public func execute(_ input: Input) async throws -> Output {
        try await operation(input)
    }
}
