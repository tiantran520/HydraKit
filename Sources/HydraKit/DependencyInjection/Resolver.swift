import Foundation

/// A type that resolves dependencies by type.
public protocol Resolver: AnyObject {
    /// Resolves a registered dependency.
    /// - Parameter type: The dependency type to resolve.
    /// - Returns: The resolved dependency.
    func resolve<Service>(_ type: Service.Type) -> Service
}

public extension Resolver {
    /// Resolves a registered dependency using type inference.
    /// - Returns: The resolved dependency.
    func resolve<Service>() -> Service {
        resolve(Service.self)
    }
}
