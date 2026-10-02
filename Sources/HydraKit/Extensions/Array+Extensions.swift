import Foundation

/// Convenience helpers for working with arrays.
public extension Array {
    /// Safely returns an element when the index is within bounds.
    /// - Parameter index: The index to access.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    /// Returns the array split into chunks of a maximum size.
    /// - Parameter size: The maximum number of elements per chunk.
    /// - Returns: An array of element chunks.
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

/// Convenience helpers for arrays whose elements are equatable.
public extension Array where Element: Equatable {
    /// Returns a copy of the array with duplicate elements removed while preserving order.
    var removingDuplicates: [Element] {
        reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}
