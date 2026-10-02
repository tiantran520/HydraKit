import Foundation

/// A lightweight form validator.
public struct FormValidator<Value>: Sendable {
    /// A validation rule.
    public struct Rule: Sendable {
        /// Validation message returned when validation fails.
        public let message: String
        private let isValid: @Sendable (Value) -> Bool

        /// Creates a validation rule.
        public init(message: String, isValid: @escaping @Sendable (Value) -> Bool) {
            self.message = message
            self.isValid = isValid
        }

        /// Evaluates the rule.
        public func callAsFunction(_ value: Value) -> Bool {
            isValid(value)
        }
    }

    private let rules: [Rule]

    /// Creates a validator.
    public init(rules: [Rule]) {
        self.rules = rules
    }

    /// Returns the first validation error for a value.
    public func firstError(for value: Value) -> String? {
        rules.first { !$0(value) }?.message
    }
}

public extension FormValidator where Value == String {
    /// A validator that requires non-empty text.
    static func required(_ message: String = "Trường này là bắt buộc.") -> FormValidator<String> {
        FormValidator(rules: [
            Rule(message: message) { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        ])
    }
}
