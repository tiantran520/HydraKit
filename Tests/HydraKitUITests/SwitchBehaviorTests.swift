import SwiftUI
import XCTest
@testable import HydraKitUI

final class SwitchBehaviorTests: XCTestCase {
    @MainActor
    func testSwitchActivationWritesParentBindingOnce() {
        var selected = false
        var writes = 0
        let binding = Binding(get: { selected }, set: { selected = $0; writes += 1 })
        let control = HKSwitch("Appearance", isOn: binding)
        control.performToggle(isEnabled: true)
        XCTAssertTrue(selected)
        XCTAssertEqual(writes, 1)
        control.performToggle(isEnabled: true)
        XCTAssertFalse(selected)
        XCTAssertEqual(writes, 2)
    }

    @MainActor
    func testDisabledSwitchDoesNotWriteBinding() {
        var selected = true
        var writes = 0
        let control = HKSwitch("Appearance", isOn: Binding(get: { selected }, set: { selected = $0; writes += 1 }))
        control.performToggle(isEnabled: false)
        XCTAssertTrue(selected)
        XCTAssertEqual(writes, 0)
    }

    @MainActor
    func testActivationUsesLatestParentValue() {
        var selected = false
        let control = HKSwitch("Appearance", isOn: Binding(get: { selected }, set: { selected = $0 }))
        selected = true
        control.performToggle(isEnabled: true)
        XCTAssertFalse(selected)
    }
}
