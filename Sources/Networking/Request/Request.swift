import Foundation

public protocol Request {
  var httpMethod: HTTPMethod { get }
  var baseUrlString: String { get }
  var parameters: [HTTPParameter]? { get }
  var headers: [HTTPHeader]? { get }
  var body: HTTPBody? { get }
  var timeoutInterval: TimeInterval { get }
  var cachePolicy: URLRequest.CachePolicy { get }
}

extension Request {
  public var timeoutInterval: TimeInterval { 60 }
  public var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }

  public var urlRequest: URLRequest? {
    guard let url = URL(string: baseUrlString) else {
      return nil
    }

    var request = URLRequest(url: url)
    request.httpMethod = httpMethod.rawValue
    request.httpBody = body?.data
    request.timeoutInterval = timeoutInterval
    request.cachePolicy = cachePolicy

    if let parameters = parameters {
      try? HTTPParameterEncoderImpl().encodeParameters(for: &request, with: parameters)
    }

    if let headers = headers {
      HTTPHeaderEncoderImpl().encodeHeaders(for: &request, with: headers)
    }

    return request
  }
}

internal struct EZRequest: Request {
  var httpMethod: HTTPMethod
  var baseUrlString: String
  var parameters: [HTTPParameter]?
  var headers: [HTTPHeader]?
  var body: HTTPBody?
  var timeoutInterval: TimeInterval
  var cachePolicy: URLRequest.CachePolicy
}
