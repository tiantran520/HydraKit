import XCTest
@testable import HydraKitDomain

final class HydraKitDomainTests: XCTestCase {
    func testPlaceholder() {
        XCTAssertEqual(HKHydraKitDomain.version, "0.1.0")
    }
}
