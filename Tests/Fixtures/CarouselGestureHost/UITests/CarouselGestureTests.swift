import XCTest

final class CarouselGestureTests: XCTestCase {
    func testLTR() { checkSwipes(rtl: false, small: false) }
    func testRTL() { checkSwipes(rtl: true, small: false) }
    func testSmallCardsLTR() { checkSwipes(rtl: false, small: true) }
    func testSmallCardsRTL() { checkSwipes(rtl: true, small: true) }

    private func checkSwipes(rtl: Bool, small: Bool) {
        let app = XCUIApplication()
        app.launchArguments = (rtl ? ["--rtl"] : []) + (small ? ["--small-cards"] : [])
        app.launch()
        let selected = app.staticTexts["selection"]
        expect(selected, value: 4)
        let scroll = app.scrollViews.firstMatch
        XCTAssertTrue(scroll.waitForExistence(timeout: 5))
        expectCentered(app, id: 4)
        scroll.swipeLeft(velocity: .fast)
        expect(selected, value: rtl ? 3 : 5)
        expectCentered(app, id: rtl ? 3 : 5)
        scroll.swipeRight(velocity: .fast)
        expect(selected, value: 4)
        expectCentered(app, id: 4)
        app.buttons["Resize"].tap()
        expect(selected, value: 4)
        expectCentered(app, id: 4)
        scroll.swipeLeft(velocity: .fast)
        expect(selected, value: rtl ? 3 : 5)
        expectCentered(app, id: rtl ? 3 : 5)
        app.buttons["Last"].tap()
        expect(selected, value: 8)
        expectCentered(app, id: 8)
        app.buttons["Resize"].tap()
        expect(selected, value: 8)
        expectCentered(app, id: 8)
        app.buttons["First"].tap()
        expect(selected, value: 0)
        expectCentered(app, id: 0)
        app.buttons["Last"].tap()
        expect(selected, value: 8)
        expectCentered(app, id: 8)
        if rtl { scroll.swipeRight(velocity: .fast) }
        else { scroll.swipeLeft(velocity: .fast) }
        expect(selected, value: 8)
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    private func expectCentered(_ app: XCUIApplication, id: Int, file: StaticString = #filePath, line: UInt = #line) {
        let card = app.descendants(matching: .any).matching(identifier: "card-\(id)").firstMatch
        XCTAssertTrue(card.exists, file: file, line: line)
        XCTAssertEqual(card.frame.midX, app.scrollViews.firstMatch.frame.midX, accuracy: 2,
                       "Selected card must be visually centered", file: file, line: line)
    }

    private func expect(_ element: XCUIElement, value: Int, file: StaticString = #filePath, line: UInt = #line) {
        let matched = XCTNSPredicateExpectation(predicate: NSPredicate(format: "label == %@", String(value)), object: element)
        XCTAssertEqual(XCTWaiter.wait(for: [matched], timeout: 5), .completed, "Expected selection \(value), got \(element.label)", file: file, line: line)
    }
}
