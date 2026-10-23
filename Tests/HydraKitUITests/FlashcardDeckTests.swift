import SwiftUI
import XCTest
@testable import HydraKitUI

final class FlashcardDeckTests: XCTestCase {
    func testSwipeRequiresHorizontalIntentAndAcceptsDeliberateFlick() {
        XCTAssertEqual(HKFlashcardSwipe.resolve(translation: CGSize(width: 100, height: 10), predicted: .zero, width: 320, threshold: 0.25), .right)
        XCTAssertEqual(HKFlashcardSwipe.resolve(translation: CGSize(width: -20, height: 2), predicted: CGSize(width: -150, height: 0), width: 320, threshold: 0.25), .left)
        XCTAssertNil(HKFlashcardSwipe.resolve(translation: CGSize(width: 20, height: 100), predicted: CGSize(width: 200, height: 300), width: 320, threshold: 0.25))
        XCTAssertNil(HKFlashcardSwipe.resolve(translation: CGSize(width: 3, height: 1), predicted: CGSize(width: 200, height: 0), width: 320, threshold: 0.25))
        XCTAssertNil(HKFlashcardSwipe.resolve(translation: CGSize(width: 30, height: 1), predicted: CGSize(width: 40, height: 0), width: 320, threshold: 0.25))
    }

    func testOnlyCurrentCardCanBeConsumedAndNextStartsOnFront() {
        var state = HKFlashcardDeckState<Int>()
        state.reconcile(ids: [1, 2, 3])
        state.isFlipped = true
        XCTAssertFalse(state.consume(2, ids: [1, 2, 3]))
        XCTAssertEqual(state.currentID, 1)
        XCTAssertTrue(state.consume(1, ids: [1, 2, 3]))
        XCTAssertEqual(state.currentID, 2)
        XCTAssertFalse(state.isFlipped)
        XCTAssertFalse(state.consume(1, ids: [1, 2, 3]))
    }

    func testReorderingPreservesCurrentFaceAndSkipsConsumedIDs() {
        var state = HKFlashcardDeckState<Int>()
        state.reconcile(ids: [1, 2, 3])
        XCTAssertTrue(state.consume(1, ids: [1, 2, 3]))
        state.isFlipped = true
        state.reconcile(ids: [3, 1, 2])
        XCTAssertEqual(state.currentID, 2)
        XCTAssertTrue(state.isFlipped)
        XCTAssertEqual(state.remaining(ids: [3, 1, 2]), [2, 3])
        state.reconcile(ids: [1, 3])
        XCTAssertEqual(state.currentID, 3)
        XCTAssertFalse(state.isFlipped)
    }

    func testCompletionAppendAndRestart() {
        var state = HKFlashcardDeckState<Int>()
        state.reconcile(ids: [1])
        XCTAssertTrue(state.consume(1, ids: [1]))
        XCTAssertNil(state.currentID)
        XCTAssertTrue(state.remaining(ids: [1]).isEmpty)
        state.reconcile(ids: [1, 2])
        XCTAssertEqual(state.currentID, 2)
        XCTAssertEqual(state.remaining(ids: [1, 2]), [2])
        state.restart(ids: [1, 2])
        XCTAssertEqual(state.currentID, 1)
        XCTAssertEqual(state.remaining(ids: [1, 2]), [1, 2])
        state.reconcile(ids: [])
        XCTAssertNil(state.currentID)
        XCTAssertFalse(state.isFlipped)
    }

    func testInvalidGestureGeometryDoesNotCommit() {
        XCTAssertNil(HKFlashcardSwipe.resolve(translation: CGSize(width: CGFloat.infinity, height: 0), predicted: .zero, width: 320, threshold: 0.25))
        XCTAssertNil(HKFlashcardSwipe.resolve(translation: CGSize(width: 100, height: 0), predicted: .zero, width: 0, threshold: 0.25))
    }
}
