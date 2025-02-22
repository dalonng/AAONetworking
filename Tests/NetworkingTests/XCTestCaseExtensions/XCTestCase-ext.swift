import XCTest

extension XCTestCase {
  func assertThrowsErrorAsync(
    _ expression: @escaping @autoclosure () async throws -> some Any,
    errorHandler: (Error) -> Void = { _ in }
  ) async {
    do {
      _ = try await expression()
      XCTFail("Expected to throw an error, but no error was thrown", file: #filePath, line: #line)
    } catch {
      errorHandler(error)
    }
  }

  func assertNoThrowAsync(
    _ expression: @escaping @autoclosure () async throws -> some Any,
    message: String = "Expected no error, but an error was thrown."
  ) async {
    do {
      _ = try await expression()
    } catch {
      XCTFail("\(message) Error: \(error)", file: #filePath, line: #line)
    }
  }
}
