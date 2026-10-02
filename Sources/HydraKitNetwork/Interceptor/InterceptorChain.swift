import Foundation

/// A chain-of-responsibility pipeline for request and response interceptors.
public final class HKInterceptorChain: @unchecked Sendable {
    private let lock = NSRecursiveLock()
    private var requestInterceptors: [any RequestInterceptor]
    private var responseInterceptors: [any ResponseInterceptor]

    /// Creates an interceptor chain.
    /// - Parameters:
    ///   - requestInterceptors: Initial request interceptors.
    ///   - responseInterceptors: Initial response interceptors.
    public init(
        requestInterceptors: [any RequestInterceptor] = [],
        responseInterceptors: [any ResponseInterceptor] = []
    ) {
        self.requestInterceptors = requestInterceptors
        self.responseInterceptors = responseInterceptors
    }

    /// The current request interceptor identifiers in execution order.
    public var requestInterceptorIDs: [String] {
        lock.withLock {
            requestInterceptors.map(\.id)
        }
    }

    /// The current response interceptor identifiers in execution order.
    public var responseInterceptorIDs: [String] {
        lock.withLock {
            responseInterceptors.map(\.id)
        }
    }

    /// Adds a request interceptor at runtime.
    /// - Parameter interceptor: The interceptor to append to the chain.
    public func addRequestInterceptor(_ interceptor: any RequestInterceptor) {
        lock.withLock {
            removeRequestInterceptorLocked(id: interceptor.id)
            requestInterceptors.append(interceptor)
        }
    }

    /// Adds a response interceptor at runtime.
    /// - Parameter interceptor: The interceptor to append to the chain.
    public func addResponseInterceptor(_ interceptor: any ResponseInterceptor) {
        lock.withLock {
            removeResponseInterceptorLocked(id: interceptor.id)
            responseInterceptors.append(interceptor)
        }
    }

    /// Removes a request interceptor at runtime.
    /// - Parameter id: The identifier to remove.
    public func removeRequestInterceptor(id: String) {
        lock.withLock {
            removeRequestInterceptorLocked(id: id)
        }
    }

    /// Removes a response interceptor at runtime.
    /// - Parameter id: The identifier to remove.
    public func removeResponseInterceptor(id: String) {
        lock.withLock {
            removeResponseInterceptorLocked(id: id)
        }
    }

    /// Removes request and response interceptors that match an identifier.
    /// - Parameter id: The identifier to remove from both chains.
    public func removeInterceptor(id: String) {
        lock.withLock {
            removeRequestInterceptorLocked(id: id)
            removeResponseInterceptorLocked(id: id)
        }
    }

    /// Applies request interceptors in order.
    /// - Parameter request: The initial request.
    /// - Returns: The intercepted request.
    public func intercept(_ request: URLRequest) async throws -> URLRequest {
        let interceptors = lock.withLock { requestInterceptors }
        var current = request

        for interceptor in interceptors {
            try Task.checkCancellation()
            current = try await interceptor.intercept(current)
        }

        return current
    }

    /// Applies response interceptors in order.
    /// - Parameter response: The initial response.
    /// - Returns: The intercepted response.
    public func intercept(_ response: Response<Data>) async throws -> Response<Data> {
        let interceptors = lock.withLock { responseInterceptors }
        var current = response

        for interceptor in interceptors {
            try Task.checkCancellation()
            current = try await interceptor.intercept(current)
        }

        return current
    }

    private func removeRequestInterceptorLocked(id: String) {
        requestInterceptors.removeAll { $0.id == id }
    }

    private func removeResponseInterceptorLocked(id: String) {
        responseInterceptors.removeAll { $0.id == id }
    }
}
