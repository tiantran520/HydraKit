import Foundation
import HydraKit

/// A dependency resolver designed for tests.
public final class HKMockDIContainer: Resolver {
    private var services: [ObjectIdentifier: Any] = [:]
    private let lock = NSRecursiveLock()

    /// Creates an empty mock container.
    public init() {}

    /// Registers a service instance for a type.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - service: The service instance to return when resolved.
    public func register<Service>(
        _ type: Service.Type = Service.self,
        service: Service
    ) {
        lock.withLock {
            services[ObjectIdentifier(type)] = service
        }
    }

    /// Resolves a service by type.
    /// - Parameter type: The service type to resolve.
    /// - Returns: The registered service.
    public func resolve<Service>(_ type: Service.Type = Service.self) -> Service {
        lock.withLock {
            guard let service = services[ObjectIdentifier(type)] as? Service else {
                preconditionFailure("No mock dependency registered for \(type)")
            }
            return service
        }
    }

    /// Removes all registered services.
    public func reset() {
        lock.withLock {
            services.removeAll()
        }
    }
}
