import XCTest

final class FlashcardDeckUITests: XCTestCase {
    func testFlipSwipeBothDirectionsCompleteAndRestart() { study(rtl: false) }
    func testStudyInRTL() { study(rtl: true) }

    private func study(rtl: Bool) {
        let app = XCUIApplication()
        app.launchArguments = rtl ? ["--rtl"] : []
        app.launch()
        let first = app.buttons["Place 0"]
        XCTAssertTrue(first.waitForExistence(timeout: 5))
        attach(app, "Place front")
        first.tap()
        XCTAssertTrue(app.buttons["Description 0"].waitForExistence(timeout: 3))
        attach(app, "English description back")
        app.buttons["Description 0"].tap()
        XCTAssertTrue(first.waitForExistence(timeout: 3))
        first.swipeLeft(velocity: .fast)
        expect(app.staticTexts["swipes"], "1")
        expect(app.staticTexts["last-swipe"], "0:left")
        XCTAssertTrue(app.buttons["Place 1"].exists)
        XCTAssertFalse(app.buttons["Description 1"].exists)
        app.buttons["Flip card"].tap()
        XCTAssertTrue(app.buttons["Description 1"].waitForExistence(timeout: 3))
        app.buttons["Learned"].tap()
        expect(app.staticTexts["swipes"], "2")
        expect(app.staticTexts["last-swipe"], "1:right")
        app.buttons["Place 2"].swipeRight(velocity: .fast)
        expect(app.staticTexts["swipes"], "3")
        expect(app.staticTexts["completions"], "1")
        let restart = app.buttons["Start again"]
        XCTAssertTrue(restart.exists)
        attach(app, "Session complete")
        restart.tap()
        XCTAssertTrue(app.buttons["Place 0"].waitForExistence(timeout: 3))
        expect(app.staticTexts["completions"], "1")
        app.buttons["Review"].tap()
        expect(app.staticTexts["last-swipe"], "0:left")
        expect(app.staticTexts["swipes"], "4")
    }

    func testDisabledDoesNotFlipOrSwipe() {
        let app = XCUIApplication()
        app.launchArguments = ["--disabled"]
        app.launch()
        let card = app.buttons["Place 0"]
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        card.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        card.swipeLeft()
        expect(app.staticTexts["swipes"], "0")
        XCTAssertTrue(card.exists)
        XCTAssertFalse(app.buttons["Description 0"].exists)
    }

    func testShortAndVerticalDragDoNotSwipeOrFlip() {
        let app = XCUIApplication()
        app.launch()
        let card = app.buttons["Place 0"]
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        let start = card.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        start.press(forDuration: 0.05, thenDragTo: start.withOffset(CGVector(dx: -25, dy: 0)),
                    withVelocity: XCUIGestureVelocity(rawValue: 30), thenHoldForDuration: 0.4)
        XCTAssertTrue(card.exists, "A short horizontal drag must return to the front")
        XCTAssertFalse(app.buttons["Description 0"].exists)
        card.swipeDown()
        expect(app.staticTexts["swipes"], "0")
        XCTAssertTrue(card.exists)
        XCTAssertFalse(app.buttons["Description 0"].exists)
    }

    func testParentMayRemoveSwipedDataAndInitiallyEmptyDoesNotComplete() {
        let app = XCUIApplication()
        app.launchArguments = ["--remove-on-swipe"]
        app.launch()
        for index in 0..<3 {
            app.buttons["Learned"].tap()
            expect(app.staticTexts["swipes"], "\(index + 1)")
        }
        expect(app.staticTexts["completions"], "1")
        XCTAssertFalse(app.buttons["Start again"].exists)
        app.terminate()
        app.launchArguments = ["--empty"]
        app.launch()
        expect(app.staticTexts["completions"], "0")
        XCTAssertFalse(app.buttons["Start again"].exists)
    }

    func testVerticalDragOverCardScrollsTheParentPage() {
        checkParentScroll(plain: false)
    }

    func testCoveringContentDoesNotSwipeTheUnderlyingDeck() {
        let app = XCUIApplication()
        app.launchArguments = ["--cover"]
        app.launch()
        let cover = app.staticTexts["cover"]
        XCTAssertTrue(cover.waitForExistence(timeout: 5))
        cover.swipeLeft(velocity: .fast)
        expect(app.staticTexts["cover-drags"], "1")
        expect(app.staticTexts["swipes"], "0")
    }

    func testParentScrollCalibrationWithNativeButton() {
        checkParentScroll(plain: true)
    }

    private func checkParentScroll(plain: Bool) {
        let app = XCUIApplication()
        app.launchArguments = plain ? ["--scroll", "--plain-card"] : ["--scroll"]
        app.launch()
        let card = app.buttons["Place 0"]
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        let initialY = card.frame.minY
        card.swipeUp(velocity: .fast)
        attach(app, "Parent scroll after vertical drag")
        let scrolled = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in
            card.frame.minY < initialY - 40
        }, object: nil)
        XCTAssertEqual(XCTWaiter.wait(for: [scrolled], timeout: 3), .completed,
                       "Card frame must move with parent scrolling")
        expect(app.staticTexts["swipes"], "0")
        XCTAssertFalse(app.buttons["Description 0"].exists)
        app.scrollViews.firstMatch.swipeDown(velocity: .fast)
        let top = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in
            abs(card.frame.minY - initialY) < 5
        }, object: nil)
        XCTAssertEqual(XCTWaiter.wait(for: [top], timeout: 3), .completed)
        XCTAssertTrue(card.isHittable)
        if plain { return }
        card.swipeLeft(velocity: .fast)
        expect(app.staticTexts["swipes"], "1")
        expect(app.staticTexts["last-swipe"], "0:left")
    }

    private func expect(_ element: XCUIElement, _ value: String, file: StaticString = #filePath, line: UInt = #line) {
        let matched = XCTNSPredicateExpectation(predicate: NSPredicate(format: "label == %@", value), object: element)
        XCTAssertEqual(XCTWaiter.wait(for: [matched], timeout: 5), .completed,
                       "Expected \(value), got \(element.label)", file: file, line: line)
    }

    private func attach(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
