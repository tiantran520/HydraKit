import XCTest
@testable import HydraKitTesting

final class HydraKitTestingTests: XCTestCase {
    func testPlaceholder() {
        XCTAssertEqual(HKHydraKitTesting.version, "0.1.0")
    }
}
