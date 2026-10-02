import Foundation
import Network

/// The current network reachability status.
public enum HKConnectionStatus: Equatable, Sendable {
    /// The network is reachable.
    case connected(interface: HKInterface)

    /// The network is not reachable.
    case disconnected

    /// The network status is not known yet.
    case unknown

    /// A network interface type.
    public enum HKInterface: String, Equatable, Sendable {
        /// Wi-Fi connectivity.
        case wifi

        /// Cellular connectivity.
        case cellular

        /// Wired Ethernet connectivity.
        case wiredEthernet

        /// Loopback connectivity.
        case loopback

        /// Another interface type.
        case other
    }

    /// A Boolean value indicating whether the connection is reachable.
    public var isConnected: Bool {
        if case .connected = self {
            return true
        }
        return false
    }
}

extension HKConnectionStatus {
    /// Creates a connection status from a network path.
    /// - Parameter path: The network path to map.
    init(path: NWPath) {
        guard path.status == .satisfied else {
            self = .disconnected
            return
        }

        if path.usesInterfaceType(.wifi) {
            self = .connected(interface: .wifi)
        } else if path.usesInterfaceType(.cellular) {
            self = .connected(interface: .cellular)
        } else if path.usesInterfaceType(.wiredEthernet) {
            self = .connected(interface: .wiredEthernet)
        } else if path.usesInterfaceType(.loopback) {
            self = .connected(interface: .loopback)
        } else {
            self = .connected(interface: .other)
        }
    }
}
