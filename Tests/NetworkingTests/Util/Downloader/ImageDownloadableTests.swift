import XCTest

@testable import AAONetworking

final class ImageDownloadableTests: XCTestCase {
  // MARK: test Async/Await

  func testDownloadImageSuccess() async throws { // note: this is an async test as it actually decodes url to generate the image
    let testURL = URL(string: "https://i.natgeofe.com/n/4f5aaece-3300-41a4-b2a8-ed2708a0a27c/domestic-dog_thumb_square.jpg")!
    let sut = ImageDownloader()
    do {
      _ = try await sut.downloadImage(from: testURL)
      XCTAssertTrue(true)
    } catch {
      XCTFail()
    }
  }

  func testDownloadImageFails() async throws {
    let testURL = URL(string: "https://i.natgeofe.com/n/4f5aaece-3300-41a4-b2a8-ed2708a0a27c/domestic-dog_thumb_square.jpg")!
    let urlSession = MockURLSession(
      data: mockPersonJsonData,
      url: testURL,
      urlResponse: buildResponse(statusCode: 200),
      error: nil)
    let validator = MockURLResponseValidator(throwError: NetworkingError.httpClientError(.badRequest, [:]))
    let sut = ImageDownloader(
      urlSession: urlSession,
      validator: validator,
      requestDecoder: RequestDecoder())
    do {
      _ = try await sut.downloadImage(from: testURL)
      XCTFail()
    } catch let error as NetworkingError {
      XCTAssertEqual(error, NetworkingError.httpClientError(.badRequest, [:]))
    }
  }

  private func buildResponse(statusCode: Int) -> HTTPURLResponse {
    HTTPURLResponse(
      url: URL(string: "https://example.com")!,
      statusCode: statusCode,
      httpVersion: nil,
      headerFields: nil)!
  }
}
