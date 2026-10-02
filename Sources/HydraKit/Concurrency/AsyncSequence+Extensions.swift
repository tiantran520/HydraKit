import Foundation

/// Convenience helpers for async sequences.
public extension AsyncSequence {
    /// Collects all elements from the sequence into an array.
    /// - Returns: An array containing each emitted element.
    func collect() async rethrows -> [Element] {
        var elements: [Element] = []
        for try await element in self {
            elements.append(element)
        }
        return elements
    }

    /// Returns the first element that satisfies the predicate.
    /// - Parameter predicate: A closure that evaluates each element.
    /// - Returns: The first matching element, or `nil`.
    func first(where predicate: (Element) async throws -> Bool) async rethrows -> Element? {
        for try await element in self {
            if try await predicate(element) {
                return element
            }
        }
        return nil
    }
}
