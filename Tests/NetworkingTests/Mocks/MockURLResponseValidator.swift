import AAONetworking
import Foundation

struct MockURLResponseValidator: ResponseValidator {
  var throwError: NetworkingError? = nil

  func validateNoError(_ error: (any Error)?) throws {
    if let throwError = throwError {
      throw throwError
    }
  }

  func validateStatus(from urlResponse: URLResponse?) throws {
    if let throwError = throwError {
      throw throwError
    }
  }

  func validateData(_ data: Data?) throws -> Data {
    if let throwError = throwError {
      throw throwError
    }
    guard let data else {
      throw NetworkingError.internalError(.noData)
    }
    return data
  }

  func validateUrl(_ url: URL?) throws -> URL {
    if let throwError = throwError {
      throw throwError
    }
    guard let url else {
      throw NetworkingError.internalError(.noURL)
    }
    return url
  }
}
