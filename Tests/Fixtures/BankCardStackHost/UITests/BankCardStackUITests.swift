import XCTest

final class BankCardStackUITests: XCTestCase {
    func testHomeGesturesAndSelection() { checkGestures(rtl: false) }
    func testHomeGesturesAndSelectionRTL() { checkGestures(rtl: true) }

    private func checkGestures(rtl: Bool) {
        let app = XCUIApplication()
        app.launchArguments = rtl ? ["--rtl"] : []
        app.launch()
        let stack = app.otherElements["bank-stack"].firstMatch
        XCTAssertTrue(stack.waitForExistence(timeout: 5))
        expect(app.staticTexts["mode"], "collapsed")
        stack.swipeRight()
        expect(app.staticTexts["mode"], "fanned")
        attach(app, "Fan")
        stack.swipeLeft()
        expect(app.staticTexts["mode"], "collapsed")
        stack.swipeDown()
        expect(app.staticTexts["mode"], "expanded")
        attach(app, "Expanded")
        stack.swipeUp()
        expect(app.staticTexts["mode"], "collapsed")
        app.buttons["Card 0"].tap()
        expect(app.staticTexts["selection"], "0")
        expect(app.staticTexts["selections"], "1")
        let absent = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"), object: app.buttons["Card 1"])
        XCTAssertEqual(XCTWaiter.wait(for: [absent], timeout: 3), .completed,
                       "Hidden cards must leave the accessibility tree")
        stack.swipeDown()
        expect(app.staticTexts["mode"], "collapsed")
        app.buttons["Back"].tap()
        expect(app.staticTexts["selection"], "-1")
        attach(app, "Collapsed")
    }

    func testExpandedLeftSwipeRevealsDeleteRequest() {
        let app = XCUIApplication()
        app.launchArguments = ["--expanded"]
        app.launch()
        app.buttons["Card 0"].swipeLeft()
        let remove = app.buttons["Remove card"]
        XCTAssertTrue(remove.waitForExistence(timeout: 5))
        attach(app, "Delete reveal")
        remove.tap()
        expect(app.staticTexts["deletes"], "1")
        expect(app.staticTexts["selection"], "-1")
        XCTAssertTrue(app.buttons["Card 0"].exists)
    }

    func testDisabledStackDoesNotSwipeOrSelect() {
        let app = XCUIApplication()
        app.launchArguments = ["--disabled"]
        app.launch()
        let stack = app.otherElements["bank-stack"].firstMatch
        stack.swipeDown()
        expect(app.staticTexts["mode"], "collapsed")
        stack.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8)).tap()
        expect(app.staticTexts["selection"], "-1")
        expect(app.staticTexts["selections"], "0")
    }

    func testLocalSelectionCanReturnByTappingFocusedCard() {
        let app = XCUIApplication()
        app.launchArguments = ["--local"]
        app.launch()
        let stack = app.otherElements["bank-stack"].firstMatch
        let initialHeight = stack.frame.height
        app.buttons["Card 0"].tap()
        expect(app.staticTexts["selections"], "1")
        XCTAssertLessThan(stack.frame.height, initialHeight - 20)
        app.buttons["Card 0"].tap()
        let settled = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in
            abs(stack.frame.height - initialHeight) < 1
        }, object: nil)
        XCTAssertEqual(XCTWaiter.wait(for: [settled], timeout: 3), .completed)
        expect(app.staticTexts["selections"], "1")
    }

    func testDeleteIsAvailableWithoutSwipe() {
        let app = XCUIApplication()
        app.launchArguments = ["--expanded"]
        app.launch()
        app.buttons["Card 0"].press(forDuration: 1)
        let remove = app.buttons["Remove card"]
        guard remove.waitForExistence(timeout: 3) else { XCTFail("Deletion needs a native menu alternative"); return }
        remove.tap()
        expect(app.staticTexts["deletes"], "1")
        expect(app.staticTexts["selection"], "-1")
    }

    func testRearCardDeleteTargetPreservesMinimumSize() {
        let app = XCUIApplication()
        app.launchArguments = ["--expanded"]
        app.launch()
        app.buttons["Card 4"].swipeLeft()
        let remove = app.buttons["Remove card"]
        guard remove.waitForExistence(timeout: 5) else { XCTFail("Rear card must reveal its action"); return }
        // XCTest reports the image glyph's bounds for this native plain button.
        // Exercise the actual target near opposite corners of the minimum 44pt square.
        let center = remove.frame
        app.coordinate(withNormalizedOffset: .zero)
            .withOffset(CGVector(dx: center.midX + 20, dy: center.midY + 20)).tap()
        expect(app.staticTexts["deletes"], "1")
        app.buttons["Card 4"].swipeLeft()
        XCTAssertTrue(remove.waitForExistence(timeout: 5))
        let secondCenter = remove.frame
        app.coordinate(withNormalizedOffset: .zero)
            .withOffset(CGVector(dx: secondCenter.midX - 20, dy: secondCenter.midY - 20)).tap()
        expect(app.staticTexts["deletes"], "2")
    }

    private func expect(_ element: XCUIElement, _ value: String, file: StaticString = #filePath, line: UInt = #line) {
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "label == %@", value), object: element)
        XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 5), .completed,
                       "Expected \(value), got \(element.label)", file: file, line: line)
    }

    private func attach(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
