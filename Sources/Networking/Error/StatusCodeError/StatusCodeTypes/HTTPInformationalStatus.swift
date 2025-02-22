import Foundation

public enum HTTPInformationalStatus: Int, Error, Sendable {
  case continueStatus = 100
  case switchingProtocols = 101
  case processing = 102
  case unknown = -1

  public init(statusCode: Int) {
    if let error = HTTPInformationalStatus(rawValue: statusCode) {
      self = error
    } else {
      self = .unknown
    }
  }

  public var description: String { "\(self)" }
  public var statusCode: Int { self.rawValue }
}
