//
//  MockSession.swift

//
//  Created by MaraMincho on 1/17/24.
//

import Combine
import Foundation

struct MockSession: URLSessionProtocol {
  let defaultMockData: Data?
  let mockDataByURL: [String: Data]
  let response: URLResponse
  var error: URLError

  init(defaultMockData: Data?, mockDataByURL: [String: Data], response: URLResponse, error: URLError = URLError(.badURL, userInfo: [:])) {
    self.defaultMockData = defaultMockData
    self.mockDataByURL = mockDataByURL
    self.response = response
    self.error = error
  }

  func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
    return Future<(data: Data, response: URLResponse), URLError> { promise in
      if defaultMockData != nil {
        promise(.success((data: defaultMockData!, response: response)))
        return
      }
      if let urlString = request.url?.absoluteString {
        if let data = mockDataByURL[urlString] {
          promise(.success((data: data, response: response)))
          return
        }
      }
      promise(.failure(error))
    }.eraseToAnyPublisher()
  }
}
