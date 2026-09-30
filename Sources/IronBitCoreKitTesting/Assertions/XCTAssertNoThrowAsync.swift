import XCTest

/// Asserts that an asynchronous throwing expression does not throw.
/// - Parameters:
///   - message: A failure message.
///   - file: The test file.
///   - line: The test line.
///   - expression: The asynchronous throwing expression to evaluate.
/// - Returns: The expression result when it succeeds, or `nil` when it throws.
@discardableResult
public func XCTAssertNoThrowAsync<T>(
    _ message: @autoclosure () -> String = "Expression unexpectedly threw an error.",
    file: StaticString = #filePath,
    line: UInt = #line,
    _ expression: () async throws -> T
) async -> T? {
    do {
        return try await expression()
    } catch {
        XCTFail("\(message()) Error: \(error)", file: file, line: line)
        return nil
    }
}
