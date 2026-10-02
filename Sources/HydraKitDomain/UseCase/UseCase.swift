import Foundation

/// A domain use case with asynchronous execution.
public protocol UseCase: Sendable {
    /// The input type.
    associatedtype Input: Sendable

    /// The output type.
    associatedtype Output: Sendable

    /// Executes the use case.
    /// - Parameter input: The input value.
    /// - Returns: The output value.
    func execute(_ input: Input) async throws -> Output
}
