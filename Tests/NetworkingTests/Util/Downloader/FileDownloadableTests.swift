import XCTest

@testable import AAONetworking

final class FileDownloadableTests: XCTestCase {
  // MARK: test Async/Await

  func testDownloadFileSuccess() async throws {
    let testURL = URL(string: "https://example.com/example.pdf")!
    let urlSession = MockURLSession(
      url: testURL,
      urlResponse: buildResponse(statusCode: 200),
      error: nil
    )
    let validator = MockURLResponseValidator()
    let decoder = RequestDecoder()
    let sut = FileDownloader(urlSession: urlSession, validator: validator, requestDecoder: decoder)

    do {
      let localURL = try await sut.downloadFile(with: testURL)
      XCTAssertEqual(localURL.absoluteString, "file:///tmp/test.pdf")
    } catch {
      XCTFail()
    }
  }

  func testDownloadFileFailsWhenValidatorThrowsAnyError() async throws {
    let testURL = URL(string: "https://example.com/example.pdf")!
    let urlSession = MockURLSession(
      url: testURL,
      urlResponse: buildResponse(statusCode: 200),
      error: nil
    )
    let validator = MockURLResponseValidator(throwError: NetworkingError.httpClientError(.forbidden, [:]))
    let decoder = RequestDecoder()
    let sut = FileDownloader(urlSession: urlSession, validator: validator, requestDecoder: decoder)

    do {
      _ = try await sut.downloadFile(with: testURL)
      XCTFail("unexpected error")
    } catch let error as NetworkingError {
      XCTAssertEqual(error, NetworkingError.httpClientError(.forbidden, [:]))
    }
  }

  func testDownloadFileFailsWhenStatusCodeIsNot200() async throws {
    let testURL = URL(string: "https://example.com/example.pdf")!
    let urlSession = MockURLSession(
      url: testURL,
      urlResponse: buildResponse(statusCode: 400),
      error: nil
    )
    let validator = ResponseValidatorImpl()
    let decoder = RequestDecoder()
    let sut = FileDownloader(urlSession: urlSession, validator: validator, requestDecoder: decoder)

    do {
      _ = try await sut.downloadFile(with: testURL)
      XCTFail("unexpected error")
    } catch let error as NetworkingError {
      XCTAssertEqual(error, NetworkingError.httpClientError(.badRequest, [:]))
    }
  }

  func testDownloadFileFailsWhenErrorIsNotNil() async throws {
    let testURL = URL(string: "https://example.com/example.pdf")!
    let urlSession = MockURLSession(
      url: testURL,
      urlResponse: buildResponse(statusCode: 200),
      error: NetworkingError.internalError(.unknown)
    )
    let validator = ResponseValidatorImpl()
    let decoder = RequestDecoder()
    let sut = FileDownloader(urlSession: urlSession, validator: validator, requestDecoder: decoder)

    do {
      _ = try await sut.downloadFile(with: testURL)
      XCTFail("unexpected error")
    } catch let error as NetworkingError {
      XCTAssertEqual(error, NetworkingError.internalError(.unknown))
    }
  }

  // MARK: test callbacks

  private func buildResponse(statusCode: Int) -> HTTPURLResponse {
    HTTPURLResponse(
      url: URL(string: "https://example.com")!,
      statusCode: statusCode,
      httpVersion: nil,
      headerFields: nil
    )!
  }
}
