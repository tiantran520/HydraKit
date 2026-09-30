import Foundation

/// A property wrapper that resolves a dependency from a container.
@propertyWrapper
public struct Injected<Service> {
    private let resolver: Resolver

    /// Creates an injected dependency.
    /// - Parameter resolver: The resolver used to look up the service.
    public init(resolver: Resolver = DIContainer.shared) {
        self.resolver = resolver
    }

    /// The resolved dependency.
    public var wrappedValue: Service {
        resolver.resolve(Service.self)
    }
}
