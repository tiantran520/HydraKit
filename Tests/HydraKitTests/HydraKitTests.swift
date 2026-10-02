import XCTest
@testable import HydraKit

final class HydraKitTests: XCTestCase {
    func testPlaceholder() {
        XCTAssertEqual(HKHydraKit.version, "0.1.0")
    }
}
