import XCTest
@testable import HydraKitRepository

final class HydraKitRepositoryTests: XCTestCase {
    func testPlaceholder() {
        XCTAssertEqual(HKHydraKitRepository.version, "0.1.0")
    }
}
