//
//  Provider.swift

//
//  Created by MaraMincho on 1/17/24.
//

import Combine
import Foundation

// MARK: - Provider

final class Provider<T: EndPoint> {
  private let session: URLSessionProtocol

  init(session: URLSessionProtocol = URLSession.shared) {
    self.session = session
  }

  func requestData(_ service: T, successResponseCodeRange: Range<Int> = 200 ..< 300) -> AnyPublisher<Data, Error> {
    do {
      let request = try service.request()
      let publisher = session.dataTaskPublisher(for: request)
        .tryMap { [weak self] (data: Data, response: URLResponse) in
          try self?.check(response: response, range: successResponseCodeRange)
          return data
        }
        .eraseToAnyPublisher()
      return publisher
    } catch {
      return Fail(error: ProviderError.requestError).eraseToAnyPublisher()
    }
  }

  private func check(response: URLResponse, range: Range<Int>) throws {
    guard let httpResponse = response as? HTTPURLResponse else {
      throw ProviderError.httpResponseConvertError
    }
    if !range.contains(httpResponse.statusCode) {
      throw ProviderError.notMatchedStatusCode
    }
  }
}

// MARK: - ProviderError

enum ProviderError: LocalizedError {
  case requestError
  case httpResponseConvertError
  case notMatchedStatusCode

  public var errorDescription: String? {
    switch self {
    case .httpResponseConvertError:
      return .localizedStringWithFormat("리스폰스를 HTTPResponse로 변환할 수 없습니다.", "Response Convert ERROR")
    case .notMatchedStatusCode:
      return .localizedStringWithFormat("사용자가 원하는 statusCode가 아닙니다.", "StatusCode Error")
    default:
      return nil
    }
  }
}

// MARK: - URLSession + URLSessionProtocol

extension URLSession: URLSessionProtocol {
  func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
    let publisher: DataTaskPublisher = dataTaskPublisher(for: request)
    return publisher.eraseToAnyPublisher()
  }
}

// MARK: - URLSessionProtocol

protocol URLSessionProtocol {
  func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}
