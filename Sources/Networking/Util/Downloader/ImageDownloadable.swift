import Foundation

#if canImport(UIKit)
  import UIKit

  public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
  import AppKit

  public typealias PlatformImage = NSImage
#endif

public protocol ImageDownloadable {
  func downloadImage(from url: URL) async throws -> PlatformImage
}

public struct ImageDownloader: ImageDownloadable, Sendable {
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

  public func downloadImage(from url: URL) async throws -> PlatformImage {
    do {
      let (data, response) = try await urlSession.data(from: url, delegate: nil)

      try validator.validateStatus(from: response)
      let validData = try validator.validateData(data)

      let image = try getImage(from: validData)
      return image
    } catch let error as NetworkingError {
      throw error
    } catch let error as URLError {
      throw NetworkingError.urlError(error)
    } catch {
      throw NetworkingError.internalError(.unknown)
    }
  }

  private func getImage(from data: Data) throws -> PlatformImage {
    guard let image = PlatformImage(data: data) else {
      throw NetworkingError.internalError(.invalidImageData)
    }
    return image
  }
}
