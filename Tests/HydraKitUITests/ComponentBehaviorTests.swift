import XCTest
import SwiftUI
@testable import HydraKitUI

final class ComponentBehaviorTests: XCTestCase {
    @MainActor
    func testReadyButtonInvokesCallbackOncePerActivation() {
        var submissions = 0
        let button = HKButton("Save") { submissions += 1 }
        button.performAction()
        XCTAssertEqual(submissions, 1)
    }

    @MainActor
    func testLoadingButtonRejectsRepeatedSubmissions() {
        var submissions = 0
        let button = HKButton("Save", isLoading: true) { submissions += 1 }
        button.performAction()
        button.performAction()
        XCTAssertEqual(submissions, 0)
    }

    func testValidationFeedbackPreservesParentMessageAndClearsWhenValid() {
        let validator = FormValidator<String>.required("Enter your name")
        let invalid = HKTextField.State.error(validator.firstError(for: "  "))
        XCTAssertEqual(invalid.errorMessage, "Enter your name")
        XCTAssertNil(HKTextField.State.normal.errorMessage)
        XCTAssertNil(HKTextField.State.success.errorMessage)
        XCTAssertNil(HKTextField.State.error(nil).errorMessage)
        XCTAssertNil(validator.firstError(for: "Hydra"))
    }
}
