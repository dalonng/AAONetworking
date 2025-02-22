import Foundation

public protocol FileDownloadable {
  func downloadFile(with url: URL) async throws -> URL
}

public struct FileDownloader: FileDownloadable, Sendable {
  private let urlSession: URLSessionTaskProtocol
  private let validator: ResponseValidator
  private let requestDecoder: RequestDecodable

  public init(
    urlSession: URLSessionTaskProtocol = URLSession.shared,
    validator: ResponseValidator = ResponseValidatorImpl(),
    requestDecoder: RequestDecodable = RequestDecoder()
  ) {
    self.urlSession = urlSession
    self.validator = validator
    self.requestDecoder = requestDecoder
  }

  public func downloadFile(with url: URL) async throws -> URL {
    do {
      let (localURL, urlResponse) = try await urlSession.download(from: url, delegate: nil)

      try validator.validateStatus(from: urlResponse)
      let unwrappedLocalURL = try validator.validateUrl(localURL)
      return unwrappedLocalURL
    } catch let error as NetworkingError {
      throw error
    } catch let error as URLError {
      throw NetworkingError.urlError(error)
    } catch {
      throw NetworkingError.internalError(.unknown)
    }
  }
}
