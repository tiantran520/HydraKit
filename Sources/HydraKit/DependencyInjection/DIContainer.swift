import Foundation

/// A lightweight dependency injection container.
public final class HKDIContainer: Resolver {
    /// The shared container used by `Injected`.
    public static let shared = HKDIContainer()

    private var factories: [ObjectIdentifier: (Resolver) -> Any] = [:]
    private let lock = NSRecursiveLock()

    /// Creates an empty dependency injection container.
    public init() {}

    /// Registers a factory for a service type.
    /// - Parameters:
    ///   - type: The service type to register.
    ///   - factory: A closure that creates the service.
    public func register<Service>(
        _ type: Service.Type = Service.self,
        factory: @escaping (Resolver) -> Service
    ) {
        lock.lock()
        defer { lock.unlock() }
        factories[ObjectIdentifier(type)] = factory
    }

    /// Registers an already-created service instance.
    /// - Parameters:
    ///   - type: The service type to register.
    ///   - service: The service instance.
    public func register<Service>(
        _ type: Service.Type = Service.self,
        service: Service
    ) {
        register(type) { _ in service }
    }

    /// Resolves a registered service.
    /// - Parameter type: The service type to resolve.
    /// - Returns: The resolved service.
    public func resolve<Service>(_ type: Service.Type = Service.self) -> Service {
        lock.lock()
        defer { lock.unlock() }

        let key = ObjectIdentifier(type)
        guard let factory = factories[key], let service = factory(self) as? Service else {
            preconditionFailure("No dependency registered for \(type)")
        }
        return service
    }

    /// Removes all registered services.
    public func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        factories.removeAll()
    }
}
