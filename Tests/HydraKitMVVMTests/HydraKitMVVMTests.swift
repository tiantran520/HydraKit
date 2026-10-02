import XCTest
@testable import HydraKitMVVM

final class HydraKitMVVMTests: XCTestCase {
    func testPlaceholder() {
        XCTAssertEqual(HKHydraKitMVVM.version, "0.1.0")
    }
}
