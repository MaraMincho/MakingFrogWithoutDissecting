//
//  EndPoint.swift
//
//  Created by MaraMincho on 1/18/24.
//

import Combine
import Foundation

// MARK: - EndPoint

protocol EndPoint {
  var baseURL: String { get }
  var path: String? { get }
  var method: HTTPMethod { get }
  var query: Encodable? { get }
  var body: Encodable? { get }
  var headers: [String: String] { get }
}

extension EndPoint {
  func request() throws -> URLRequest {
    let path = path == nil ? "" : "/" + path!
    guard
      let tempURL = URL(string: baseURL + path),
      let targetURL = tempURL.appendQuery(query: query)
    else {
      throw EndPintError.InputURLError
    }
    var request = URLRequest(url: targetURL)
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers
    request.httpBody = try body?.data()
    return request
  }
}

extension Encodable {
  func data() throws -> Data {
    return try JSONEncoder().encode(self)
  }

  var dictionary: [String: Any] {
    guard
      let data = try? JSONEncoder().encode(self),
      let jsonData = try? JSONSerialization.jsonObject(with: data),
      let dictionaryTarget = jsonData as? [String: Any]
    else {
      return [:]
    }
    return dictionaryTarget
  }
}

extension URL {
  func appendQuery(query: Encodable?) -> URL? {
    guard let query else {
      return self
    }
    var urlComponents = URLComponents(string: absoluteString)
    urlComponents?.queryItems = query.dictionary.map { (key: String, value: Any) in
      return URLQueryItem(name: key, value: "\(value)")
    }
    return urlComponents?.url
  }
}

// MARK: - HTTPMethod

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
}

// MARK: - EndPintError

enum EndPintError: LocalizedError {
  case requestError
  case InputURLError
}
