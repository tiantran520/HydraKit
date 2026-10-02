import Foundation

/// A full repository abstraction with read, write and stream capabilities.
public protocol Repository: Readable, Writable, Streamable {}
