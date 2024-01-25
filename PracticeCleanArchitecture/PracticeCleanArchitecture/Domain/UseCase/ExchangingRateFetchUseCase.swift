//
//  ExchangingRateFetchUseCase.swift
//
//  Created by MaraMincho on 1/19/24.
//

import Combine
import Foundation
import OSLog

// MARK: - ExchangingRateFetchUseCaseRepresentable

protocol ExchangingRateFetchUseCaseRepresentable {
  func countriesPublisher() -> AnyPublisher<[ReceiveCountry], Never>
  func fetchLiveExchangingRate() -> AnyPublisher<Void, Never>
  func latestFetchedTime() -> AnyPublisher<String, Never>
}

// MARK: - ExchangingRateFetchUseCase

final class ExchangingRateFetchUseCase {
  private let repository: ExchangingRateRepositoryRepresentable
  private var receiveCountries: [ReceiveCountry]
  private let timeStampSubject: CurrentValueSubject<String, Never> = .init(" ")
  private let _countriesPublisher: CurrentValueSubject<[ReceiveCountry], Never>
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter
  }()

  private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
  }()

  var subscription: Cancellable?

  init(repository: ExchangingRateRepositoryRepresentable, receiveCountries: [ReceiveCountry]) {
    self.repository = repository
    self.receiveCountries = receiveCountries
    _countriesPublisher = .init(receiveCountries)
  }
}

// MARK: ExchangingRateFetchUseCaseRepresentable

extension ExchangingRateFetchUseCase: ExchangingRateFetchUseCaseRepresentable {
  func fetchLiveExchangingRate() -> AnyPublisher<Void, Never> {
    return repository.fetchLiveExchangingRate(targetCountryUnit: receiveCountries.map(\.unit))
      .map { [weak self] dto in
        self?.setQuotes(dto.quotes)
        self?.publishTimeStamp(dto.timestamp)
        return
      }
      .catch { error in
        print(error.localizedDescription)
        return Empty<Void, Never>().eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }

  private func setQuotes(_ quotes: [String: Double]) {
    quotes.forEach { (key: String, value: Double) in
      let unit = String(key.suffix(3))
      guard let targetIndex = receiveCountries.enumerated().filter({ $0.element.unit == unit }).last?.offset else {
        return
      }
      receiveCountries[targetIndex].quote = value
    }
    _countriesPublisher.send(receiveCountries)
  }

  func countriesPublisher() -> AnyPublisher<[ReceiveCountry], Never> {
    return _countriesPublisher.eraseToAnyPublisher()
  }

  func latestFetchedTime() -> AnyPublisher<String, Never> {
    return timeStampSubject.eraseToAnyPublisher()
  }

  private func publishTimeStamp(_ unixTime: Int) {
    let date = Date(timeIntervalSince1970: Double(unixTime))
    let resString = dateFormatter.string(from: date)
    timeStampSubject.send(resString)
  }
}
