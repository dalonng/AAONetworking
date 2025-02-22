import Foundation

public enum InternalError: Error {
  case noURL
  case couldNotParse
  case invalidError
  case noData
  case noResponse
  case requestFailed(Error)
  case noRequest
  case noHTTPURLResponse
  case invalidImageData
  case unknown
}

extension InternalError: Equatable {
  public static func == (lhs: InternalError, rhs: InternalError) -> Bool {
    switch (lhs, rhs) {
      case (.couldNotParse, .couldNotParse): true
      case (.invalidError, .invalidError): true
      case (.invalidImageData, .invalidImageData): true
      case (.noData, .noData): true
      case (.noHTTPURLResponse, .noHTTPURLResponse): true
      case (.noRequest, .noRequest): true
      case (.noResponse, .noResponse): true
      case (.noURL, .noURL): true
      case (.unknown, .unknown): true
      case (.requestFailed(let lhsError), .requestFailed(let rhsError)):
        (lhsError as NSError) == (rhsError as NSError)
      default:
        false
    }
  }
}
