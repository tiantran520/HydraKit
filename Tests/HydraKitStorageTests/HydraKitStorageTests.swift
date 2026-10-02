import XCTest
@testable import HydraKitStorage

final class HydraKitStorageTests: XCTestCase {
    func testPlaceholder() {
        XCTAssertEqual(HKHydraKitStorage.version, "0.1.0")
    }
}
