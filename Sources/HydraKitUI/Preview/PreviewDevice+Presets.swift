import SwiftUI

#if DEBUG
public extension PreviewDevice {
    /// iPhone preview device preset.
    static let hkPhone = PreviewDevice(rawValue: "iPhone 15 Pro")
    /// iPad preview device preset.
    static let hkPad = PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)")
    /// Apple Watch preview device preset.
    static let hkWatch = PreviewDevice(rawValue: "Apple Watch Series 9 (45mm)")
}
#endif
