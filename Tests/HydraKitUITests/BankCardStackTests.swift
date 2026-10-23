import SwiftUI
import XCTest
@testable import HydraKitUI

final class BankCardStackTests: XCTestCase {
    func testHomeGesturesOpenFanCloseFanAndExpandCollapse() {
        XCTAssertEqual(HKBankCardStackRules.next(.right, from: .collapsed), .fanned)
        XCTAssertEqual(HKBankCardStackRules.next(.left, from: .fanned), .collapsed)
        XCTAssertEqual(HKBankCardStackRules.next(.down, from: .collapsed), .expanded)
        XCTAssertEqual(HKBankCardStackRules.next(.up, from: .expanded), .collapsed)
        XCTAssertEqual(HKBankCardStackRules.next(.down, from: .fanned), .fanned)
    }

    func testShortDragsAndDiagonalNoiseDoNotTriggerDifferentAxis() {
        XCTAssertNil(HKBankCardStackSwipe.resolve(translation: CGSize(width: 3, height: 4), predicted: CGSize(width: 200, height: 0), threshold: 44))
        XCTAssertNil(HKBankCardStackSwipe.resolve(translation: CGSize(width: 20, height: 2), predicted: CGSize(width: 30, height: 3), threshold: 44))
        XCTAssertEqual(HKBankCardStackSwipe.resolve(translation: CGSize(width: 18, height: 80), predicted: CGSize(width: 100, height: 120), threshold: 44), .down)
        XCTAssertEqual(HKBankCardStackSwipe.resolve(translation: CGSize(width: -18, height: 2), predicted: CGSize(width: -100, height: 3), threshold: 44), .left)
    }

    func testFanAndExpandedBoundsFitNarrowAndIPadWidths() {
        for width: CGFloat in [180, 360, 768] {
            for mode: HKBankCardStackPresentation in [.collapsed, .fanned, .expanded] {
                let geometry = HKBankCardStackGeometry(width: width, cardHeight: 180, count: 5,
                                                      presentation: mode, spacing: 16, inset: 24, selectedIndex: nil)
                XCTAssertGreaterThan(geometry.height, 0)
                for index in 0..<5 {
                    let rect = geometry.bounds(of: index)
                    XCTAssertGreaterThanOrEqual(rect.minX, -0.01)
                    XCTAssertLessThanOrEqual(rect.maxX, width + 0.01)
                    XCTAssertGreaterThanOrEqual(rect.minY, -0.01)
                    XCTAssertLessThanOrEqual(rect.maxY, geometry.height + 0.01)
                }
            }
        }
    }

    func testFrontCardIsLargerAndExpansionSeparatesCards() {
        let collapsed = HKBankCardStackGeometry(width: 360, cardHeight: 180, count: 5, presentation: .collapsed, spacing: 16, inset: 24, selectedIndex: nil)
        let expanded = HKBankCardStackGeometry(width: 360, cardHeight: 180, count: 5, presentation: .expanded, spacing: 16, inset: 24, selectedIndex: nil)
        XCTAssertGreaterThan(collapsed.poses[0].scale, collapsed.poses[4].scale)
        XCTAssertGreaterThan(expanded.height, collapsed.height + 180)
        XCTAssertEqual(expanded.hitTest(CGPoint(x: 180, y: expanded.height - 30)), 0)
    }

    func testSelectedCardLiftsToUnscaledStandaloneAndEmptyCollapses() {
        let selected = HKBankCardStackGeometry(width: 360, cardHeight: 180, count: 5, presentation: .expanded, spacing: 16, inset: 24, selectedIndex: 3)
        XCTAssertEqual(selected.height, 180, accuracy: 0.01)
        XCTAssertEqual(selected.poses[3].scale, 1)
        XCTAssertEqual(selected.poses[3].angle, 0)
        let empty = HKBankCardStackGeometry(width: 360, cardHeight: 180, count: 0, presentation: .expanded, spacing: 16, inset: 24, selectedIndex: nil)
        XCTAssertEqual(empty.height, 0)
        XCTAssertTrue(empty.poses.isEmpty)
        XCTAssertNil(empty.hitTest(.zero))
    }

    @MainActor
    func testParentSelectionSurvivesReorderingAndClearsWhenRemoved() {
        struct Card: Identifiable { let id: Int }
        var selected: Int? = 1
        var writes = 0
        let binding = Binding(get: { selected }, set: { selected = $0; writes += 1 })
        let reordered = HKBankCardStack([Card(id: 2), Card(id: 1)], selection: binding, cardHeight: 180) { Text("\($0.id)") }
        reordered.reconcile()
        XCTAssertEqual(selected, 1)
        XCTAssertEqual(writes, 0)
        let removed = HKBankCardStack([Card(id: 2)], selection: binding, cardHeight: 180) { Text("\($0.id)") }
        removed.reconcile()
        XCTAssertNil(selected)
        XCTAssertEqual(writes, 1)
    }
}
