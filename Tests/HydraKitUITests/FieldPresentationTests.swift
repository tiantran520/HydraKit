import XCTest
@testable import HydraKitUI

final class FieldPresentationTests: XCTestCase {
    func testFloatingTitleRisesForFocusOrContent() {
        XCTAssertFalse(HKFieldPresentation(style: .floating, isFocused: false, hasText: false).isLabelFloating)
        XCTAssertTrue(HKFieldPresentation(style: .floating, isFocused: true, hasText: false).isLabelFloating)
        XCTAssertTrue(HKFieldPresentation(style: .floating, isFocused: false, hasText: true).isLabelFloating)
        XCTAssertTrue(HKFieldPresentation(style: .floating, isFocused: true, hasText: true).isLabelFloating)
    }

    func testStandardAndStackedNeverUseFloatingTitle() {
        for style in [HKTextFieldStyle.standard, .stacked] {
            XCTAssertFalse(HKFieldPresentation(style: style, isFocused: true, hasText: true).isLabelFloating)
        }
    }
}
