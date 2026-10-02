import XCTest
@testable import HydraKitAnalytics

final class HydraKitAnalyticsTests: XCTestCase {
    func testPlaceholder() {
        XCTAssertEqual(HKHydraKitAnalytics.version, "0.1.0")
    }
}
