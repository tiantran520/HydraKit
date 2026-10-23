import XCTest

final class WaterWaveUITests: XCTestCase {
    func testParentPercentageUpdatesNativeProgressValueAndClampsInput() {
        let app = XCUIApplication()
        app.launch()
        let gauge = app.descendants(matching: .any).matching(identifier: "water-gauge").firstMatch
        XCTAssertTrue(gauge.waitForExistence(timeout: 5))
        expect(gauge, percentage: 50)
        attach(app, "Yellow water 50 percent")
        app.buttons["Three quarters"].tap()
        expect(gauge, percentage: 75)
        app.buttons["Empty"].tap()
        expect(gauge, percentage: 0)
        app.buttons["Full"].tap()
        expect(gauge, percentage: 100)
        app.buttons["Above range"].tap()
        expect(gauge, percentage: 100)
        app.buttons["Below range"].tap()
        expect(gauge, percentage: 0)
    }

    func testColorAndPauseRetainTheExternalPercentage() {
        let app = XCUIApplication()
        app.launch()
        let gauge = app.descendants(matching: .any).matching(identifier: "water-gauge").firstMatch
        XCTAssertTrue(gauge.waitForExistence(timeout: 5))
        app.buttons["Change color"].tap()
        app.buttons["Pause waves"].tap()
        expect(gauge, percentage: 50)
        attach(app, "Blue water 50 percent paused")
    }

    private func expect(_ gauge: XCUIElement, percentage: Int, file: StaticString = #filePath, line: UInt = #line) {
        let expected = "\(percentage)%"
        let match = XCTNSPredicateExpectation(predicate: NSPredicate(format: "value == %@", expected), object: gauge)
        XCTAssertEqual(XCTWaiter.wait(for: [match], timeout: 5), .completed,
                       "Expected \(expected), got \(String(describing: gauge.value))", file: file, line: line)
    }

    private func attach(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
