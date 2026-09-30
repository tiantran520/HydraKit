import Foundation
import XCTest

/// Asserts that a condition eventually becomes true before a timeout.
/// - Parameters:
///   - timeout: The maximum number of seconds to wait.
///   - interval: The polling interval in seconds.
///   - message: A failure message.
///   - file: The test file.
///   - line: The test line.
///   - condition: The asynchronous condition to evaluate.
public func XCTAssertEventually(
    timeout: TimeInterval = 1,
    interval: TimeInterval = 0.01,
    _ message: @autoclosure () -> String = "Condition did not become true before timeout.",
    file: StaticString = #filePath,
    line: UInt = #line,
    condition: () async throws -> Bool
) async {
    let deadline = Date().addingTimeInterval(timeout)

    while Date() < deadline {
        do {
            if try await condition() {
                return
            }
        } catch {
            XCTFail("Condition threw error: \(error)", file: file, line: line)
            return
        }

        try? await Task.sleep(nanoseconds: UInt64(max(0, interval) * 1_000_000_000))
    }

    XCTFail(message(), file: file, line: line)
}
