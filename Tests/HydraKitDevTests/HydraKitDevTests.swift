import XCTest
@testable import HydraKitDev

final class HydraKitDevTests: XCTestCase {
    func testPlaceholder() {
        XCTAssertEqual(HKHydraKitDev.version, "0.1.0")
    }
}
