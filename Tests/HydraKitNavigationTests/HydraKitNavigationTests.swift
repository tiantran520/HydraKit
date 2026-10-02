import XCTest
@testable import HydraKitNavigation

final class HydraKitNavigationTests: XCTestCase {
    func testPlaceholder() {
        XCTAssertEqual(HKHydraKitNavigation.version, "0.1.0")
    }
}
