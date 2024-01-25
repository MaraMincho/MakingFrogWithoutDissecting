//
//  ExchangingRateRepository.swift
//
//  Created by MaraMincho on 1/17/24.
//

import Combine
import Foundation

// MARK: - ExchangingRateRepository

final class ExchangingRateRepository {
  private let provider: Provider<ExchangingRateLiveEndPoint>

  init(session: URLSessionProtocol = URLSession.shared) {
    provider = .init(session: session)
  }
}

// MARK: ExchangingRateRepositoryRepresentable

extension ExchangingRateRepository: ExchangingRateRepositoryRepresentable {
  func fetchLiveExchangingRate(targetCountryUnit: [String]) -> AnyPublisher<ExchangingRateDTO, Error> {
    let endPoint = ExchangingRateLiveEndPoint(targetCountryUnit: targetCountryUnit)
    return provider.requestData(endPoint)
      .tryMap { data -> ExchangingRateDTO in
        print(String(data: data, encoding: .utf8))
        let dto = try JSONDecoder().decode(ExchangingRateDTO.self, from: data)
        return dto
      }.eraseToAnyPublisher()
  }
}

// MARK: - Currencies

private struct Currencies: Encodable {
  let currencies: String
  let source = "USD"
  let format = 1
  let access_key = Bundle.main.infoDictionary?["APIKey"] as? String
  init(currencies: [String]) {
    self.currencies = currencies.joined(separator: ",")
  }
}

// MARK: - ExchangingRateLiveEndPoint

private struct ExchangingRateLiveEndPoint: EndPoint {
  var baseURL: String { return "http://apilayer.net/api" }
  var path: String? { return "live" }
  var method: HTTPMethod { return .get }
  var query: Encodable?
  var body: Encodable? { return nil }
  var headers: [String: String] { return [:] }

  init(targetCountryUnit: [String]) {
    query = Currencies(currencies: targetCountryUnit)
  }
}
