import SwiftUI
import XCTest
@testable import HydraKitUI

final class ParallaxCarouselTests: XCTestCase {
    func testStrongSwipeStopsAtAdjacentCardInEitherPhysicalDirection() {
        let paging = HKCarouselScrollBehavior(cardWidth: 288, spacing: 12, itemCount: 8)
        // Card 3 is centered at x=1044; projected momentum would skip several cards.
        XCTAssertEqual(paging.destination(originalCenter: 1044, proposedCenter: 2244), 1344)
        XCTAssertEqual(paging.destination(originalCenter: 1044, proposedCenter: 144), 744)
    }

    func testShortDragReturnsToCurrentCardAndEdgesDoNotWrap() {
        let paging = HKCarouselScrollBehavior(cardWidth: 288, spacing: 12, itemCount: 3)
        XCTAssertEqual(paging.destination(originalCenter: 444, proposedCenter: 484), 444)
        XCTAssertEqual(paging.destination(originalCenter: 144, proposedCenter: -1000), 144)
        XCTAssertEqual(paging.destination(originalCenter: 744, proposedCenter: 2000), 744)
    }

    func testSingleCardAndZeroWidthPagingRemainStable() {
        XCTAssertEqual(HKCarouselScrollBehavior(cardWidth: 288, spacing: 12, itemCount: 1)
            .destination(originalCenter: 144, proposedCenter: 744), 144)
        XCTAssertEqual(HKCarouselScrollBehavior(cardWidth: 0, spacing: 0, itemCount: 3)
            .destination(originalCenter: 0, proposedCenter: 600), 0)
    }

    func testParallaxMovesBackgroundOppositeToCardAndClampsToOverscan() {
        let geometry = HKParallaxGeometry(viewportWidth: 400, widthRatio: 0.8, strength: 0.25, reduceMotion: false)
        XCTAssertEqual(geometry.cardWidth, 320)
        XCTAssertEqual(geometry.sideInset, 40)
        XCTAssertEqual(geometry.backgroundWidth, 480)
        XCTAssertEqual(geometry.offset(cardMidX: 200), 0)
        XCTAssertEqual(geometry.offset(cardMidX: 300), -25)
        XCTAssertEqual(geometry.offset(cardMidX: 100), 25)
        XCTAssertEqual(geometry.offset(cardMidX: 2000), -80)
        XCTAssertEqual(geometry.offset(cardMidX: -2000), 80)
    }

    func testReduceMotionRemovesOffsetAndExtraImageCrop() {
        let geometry = HKParallaxGeometry(viewportWidth: 400, widthRatio: 0.8, strength: 0.25, reduceMotion: true)
        XCTAssertEqual(geometry.offset(cardMidX: 0), 0)
        XCTAssertEqual(geometry.backgroundWidth, 320)
    }

    func testInvalidGeometryDoesNotProduceNonfiniteOrNegativeLayout() {
        let zero = HKParallaxGeometry(viewportWidth: .nan, widthRatio: 0, strength: .infinity, reduceMotion: false)
        XCTAssertEqual(zero.cardWidth, 0)
        XCTAssertEqual(zero.offset(cardMidX: .infinity), 0)
        let valid = HKParallaxGeometry(viewportWidth: 400, widthRatio: 2, strength: -1, reduceMotion: false)
        XCTAssertEqual(valid.cardWidth, 400)
        XCTAssertEqual(valid.backgroundWidth, 400)
    }

    @MainActor
    func testSelectionRetainsStableIDAndRepairsRemovedOrEmptyItems() {
        var selected: Int? = 2
        var writes = 0
        let binding = Binding(get: { selected }, set: { selected = $0; writes += 1 })
        func reconcile(_ ids: [Int]) {
            let carousel = HKParallaxCarousel(ids.map(Item.init), selection: binding, cardHeight: 200) { _ in
                Color.blue
            } overlay: { item in
                Text("Card \(item.id)")
            }
            carousel.reconcileSelection()
        }
        reconcile([3, 2, 1])
        XCTAssertEqual(selected, 2)
        XCTAssertEqual(writes, 0)
        reconcile([3, 1])
        XCTAssertEqual(selected, 3)
        XCTAssertEqual(writes, 1)
        reconcile([])
        XCTAssertNil(selected)
        XCTAssertEqual(writes, 2)
        reconcile([7, 8])
        XCTAssertEqual(selected, 7)
        XCTAssertEqual(writes, 3)
    }

    private struct Item: Identifiable {
        let id: Int
    }
}
