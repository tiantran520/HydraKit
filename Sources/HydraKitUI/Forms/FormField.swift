import Foundation

/// A model representing a single form field.
public struct FormField<Value: Sendable>: Identifiable, Sendable {
    /// The field identifier.
    public let id: String
    /// The field title.
    public var title: String
    /// The current value.
    public var value: Value
    /// Optional validation message.
    public var errorMessage: String?

    /// Creates a form field.
    public init(id: String, title: String, value: Value, errorMessage: String? = nil) {
        self.id = id
        self.title = title
        self.value = value
        self.errorMessage = errorMessage
    }
}
