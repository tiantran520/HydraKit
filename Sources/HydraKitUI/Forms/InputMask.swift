import Foundation

/// Applies simple character masks to text input.
public struct InputMask: Sendable {
    /// Placeholder character used for input slots.
    public let placeholder: Character
    /// Mask pattern, for example `"###-###"`.
    public let pattern: String

    /// Creates an input mask.
    public init(pattern: String, placeholder: Character = "#") {
        self.pattern = pattern
        self.placeholder = placeholder
    }

    /// Applies the mask to a raw input string.
    public func apply(to input: String) -> String {
        var result = ""
        var inputIterator = input.filter(\.isNumber).makeIterator()

        for character in pattern {
            if character == placeholder {
                guard let next = inputIterator.next() else { break }
                result.append(next)
            } else {
                result.append(character)
            }
        }
        return result
    }
}
