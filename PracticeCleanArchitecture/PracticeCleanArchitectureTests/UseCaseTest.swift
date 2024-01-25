//
//  UseCaseTest.swift
//
//  Created by MaraMincho on 1/18/24.
//

import Combine
import UIKit
@testable import PracticeCleanArchitecture
import XCTest

// MARK: - UseCaseTest

final class UseCaseTest: XCTestCase {
  var subscriptions = Set<AnyCancellable>()
  var fetchUseCase: ExchangingRateFetchUseCaseRepresentable?
  var convertUseCase: ExchangingRateConvertUseCaseRepresentable?
  override func setUpWithError() throws {
    subscriptions.removeAll()
    fetchUseCase = nil
    convertUseCase = nil
  }

  override func tearDownWithError() throws {
    subscriptions.removeAll()
    fetchUseCase = nil
    convertUseCase = nil
  }

  func test_Repository_useCase를생성하고_1을넣어서_값이1000이나오는지확인한다() {
    // Assign
    let dto = ExchangingRateDTO(success: true, timestamp: 1_705_507_200, quotes: [
      "USDKRW": 1000,
    ])
    let repository = MockExchangingRateRepository(dto: dto)
    convertUseCase = ExchangingRateConvertUseCase()
    fetchUseCase = ExchangingRateFetchUseCase(repository: repository, receiveCountries: [.init(name: "한국", unit: "KRW")])
    let expectation = expectation(description: "값 비교 예상 변수")

    // Act
    fetchUseCase?.fetchLiveExchangingRate()
      .sink { _ in }
      .store(in: &subscriptions)

    fetchUseCase?.countriesPublisher()
      .sink { countries in
        let country = countries[0]
        let value = self.convertUseCase!.applyQuote(text: "1", quote: country.quote)
        switch value {
        case let .success(string):
          if string == "1,000.00" {
            expectation.fulfill()
          }
        default:
          XCTFail()
        }
      }
      .store(in: &subscriptions)

    // Assert
    wait(for: [expectation], timeout: 1)
  }

  func test_Repository_useCase를생성하고_Fetch후에깂을지정하지않았따면_적절한enum이오는지확인한다() {
    // Assign
    let dto = ExchangingRateDTO(success: true, timestamp: 1_705_507_200, quotes: [
      "USDKRW": 1000,
      "USDJPY": 500,
    ])
    let repository = MockExchangingRateRepository(dto: dto)
    convertUseCase = ExchangingRateConvertUseCase()
    fetchUseCase = ExchangingRateFetchUseCase(repository: repository, receiveCountries: [.init(name: "한국", unit: "KRW")])
    let expectation = expectation(description: "값 비교 예상 변수")

    // Act
    fetchUseCase?.fetchLiveExchangingRate()
      .sink { _ in }
      .store(in: &subscriptions)

    fetchUseCase?.countriesPublisher()
      .sink { countries in
        let country = countries[0]
        let value = self.convertUseCase!.applyQuote(text: "", quote: country.quote)
        switch value {
        case .emptyInput:
          expectation.fulfill()
        default:
          XCTFail()
        }
      }
      .store(in: &subscriptions)

    // Assert
    wait(for: [expectation], timeout: 1)
  }

  func test_Repository_useCase를생성하고_Fetch후에_잘못된깂을지정했다면_적절한enum이오는지확인한다() {
    // Assign
    let dto = ExchangingRateDTO(success: true, timestamp: 1_705_507_200, quotes: [
      "USDKRW": 1000,
      "USDJPY": 500,
    ])
    let repository = MockExchangingRateRepository(dto: dto)
    convertUseCase = ExchangingRateConvertUseCase()
    fetchUseCase = ExchangingRateFetchUseCase(repository: repository, receiveCountries: [.init(name: "한국", unit: "KRW"), .init(name: "일본", unit: "JPY")])
    let expectation = expectation(description: "값 비교 예상 변수")

    let inputs: [String] = ["123456", "asdw", "-11", "1a1", "0o0"]

    // Act
    fetchUseCase?.fetchLiveExchangingRate()
      .sink { _ in }
      .store(in: &subscriptions)

    fetchUseCase?.countriesPublisher()
      .sink { countries in
        let country = countries[0]
        inputs.forEach { str in
          let value = self.convertUseCase!.applyQuote(text: str, quote: country.quote)
          switch value {
          case .invalidInput:
            return
          default:
            XCTFail()
          }
        }
        expectation.fulfill()
      }
      .store(in: &subscriptions)

    // Assert
    wait(for: [expectation], timeout: 1)
  }

  func test_Repository_useCase를생성하고_Fetch후에_타임스태프를확인하여_값이맞는지확인한다() {
    // Assign
    // 2024-01-18 01:00의 타임 스탬프
    let dto = ExchangingRateDTO(success: true, timestamp: 1_705_507_200, quotes: [
      "USDKRW": 1000,
      "USDJPY": 500,
    ])
    let repository = MockExchangingRateRepository(dto: dto)
    convertUseCase = ExchangingRateConvertUseCase()
    fetchUseCase = ExchangingRateFetchUseCase(repository: repository, receiveCountries: [.init(name: "한국", unit: "KRW"), .init(name: "일본", unit: "JPY")])
    let expectation = expectation(description: "값 비교 예상 변수")

    // Act
    fetchUseCase?.fetchLiveExchangingRate()
      .sink { _ in
      }
      .store(in: &subscriptions)
    fetchUseCase?.latestFetchedTime()
      .sink { _ in

      } receiveValue: { str in
        if str == "2024-01-18 01:00" {
          expectation.fulfill()
        }
      }
      .store(in: &subscriptions)

    // Assert
    wait(for: [expectation], timeout: 1)
  }

  func test_Repository_useCase를생성하고_fetch이후에_country에quote가의도대로들어갔는지확인한다() throws {
    // Assign
    let dto = ExchangingRateDTO(success: true, timestamp: 1_705_507_200, quotes: [
      "USDKRW": 1000,
      "USDJPY": 500,
    ])
    let repository = MockExchangingRateRepository(dto: dto)
    convertUseCase = ExchangingRateConvertUseCase()
    fetchUseCase = ExchangingRateFetchUseCase(repository: repository, receiveCountries: [.init(name: "한국", unit: "KRW"), .init(name: "일본", unit: "JPY")])
    let expectation = expectation(description: "값 비교 예상 변수")

    // Act
    fetchUseCase?.countriesPublisher()
      .sink { countries in
        let value = self.convertUseCase?.applyQuote(text: "", quote: countries[0].quote)
        switch value {
        case .nowFetching:
          expectation.fulfill()
        default:
          break
        }
      }
      .store(in: &subscriptions)

    // Assert
    wait(for: [expectation], timeout: 1)
  }
}

// MARK: - MockExchangingRateRepository

private final class MockExchangingRateRepository: ExchangingRateRepositoryRepresentable {
  func fetchLiveExchangingRate(targetCountryUnit _: [String]) -> AnyPublisher<ExchangingRateDTO, Error> {
    Future<ExchangingRateDTO, Error> { [self] promise in
      if let error {
        promise(.failure(error))
      }
      promise(.success(dto))
    }.eraseToAnyPublisher()
  }

  let dto: ExchangingRateDTO
  let error: Error?
  init(dto: ExchangingRateDTO, error: Error? = nil) {
    self.dto = dto
    self.error = error
  }
}
