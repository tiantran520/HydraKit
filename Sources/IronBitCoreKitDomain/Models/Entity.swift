import Foundation

/// A domain object with stable identity.
public protocol Entity: Identifiable, Hashable, Sendable where ID: Hashable & Sendable {
    /// The entity identifier.
    var id: ID { get }
}
