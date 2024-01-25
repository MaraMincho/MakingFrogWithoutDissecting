//
//  ExchangingRateViewModel.swift
//
//  Created by MaraMincho on 1/16/24.
//

import Combine
import Foundation

// MARK: - ExchangingRateViewModelInput

struct ExchangingRateViewModelInput {
  let didSelectIndexPublisher: AnyPublisher<(row: Int, textFieldText: String?), Never>
  let textFieldTextPublisher: AnyPublisher<String?, Never>
  let fetchLiveDataPublisher: AnyPublisher<Void, Never>
}

// MARK: - ExchangingRateViewControllerState

enum ExchangingRateViewControllerState {
  case updateCountry(value: ExchangingRateViewUpdatableProperty)
  case idle
  case emptyTextField
  case wrongTextFieldText
  case updateExchangeConvertedText(value: String)
  case updateTimeStamp(time: String)
  case fetch(FetchState)
}

// MARK: - FetchState

enum FetchState {
  case firstRunning
  case running
  case done
}

typealias ExchangingRateViewModelOutput = AnyPublisher<ExchangingRateViewControllerState, Never>

// MARK: - ExchangingRateViewModelRepresentable

protocol ExchangingRateViewModelRepresentable {
  func countOfReceiveCountry() -> Int
  func pickerTitle(index: Int) -> String?
  func transform(input: ExchangingRateViewModelInput) -> ExchangingRateViewModelOutput
}

// MARK: - ExchangingRateViewModel

final class ExchangingRateViewModel {
  private let fetchUseCase: ExchangingRateFetchUseCaseRepresentable
  private let convertUseCase: ExchangingRateConvertUseCaseRepresentable

  private var subscriptions = Set<AnyCancellable>()
  private let fetchStatePublisher: CurrentValueSubject<FetchState, Never> = .init(.firstRunning)
  private let convertedValuePublisher: CurrentValueSubject<ExchangingRateViewControllerState, Never> = .init(.idle)

  private var currentIndex: Int = 0
  private var countries: [ReceiveCountry] = []

  init(fetchUseCase: ExchangingRateFetchUseCaseRepresentable, convertUseCase: ExchangingRateConvertUseCaseRepresentable) {
    self.fetchUseCase = fetchUseCase
    self.convertUseCase = convertUseCase
  }
}

// MARK: ExchangingRateViewModelRepresentable

extension ExchangingRateViewModel: ExchangingRateViewModelRepresentable {
  func transform(input: ExchangingRateViewModelInput) -> ExchangingRateViewModelOutput {
    subscriptions.removeAll()

    fetchUseCase.countriesPublisher()
      .sink { [weak self] countries in
        self?.countries = countries
      }
      .store(in: &subscriptions)

    // 현재 Fetch중인지 여부를 나타내는 Publisher입니다.
    let fetchState: ExchangingRateViewModelOutput = fetchStatePublisher
      .map { state in return ExchangingRateViewControllerState.fetch(state) }
      .eraseToAnyPublisher()

    // UseCase에 API요청을 해달라고 전달해주는 Publisher입니다.
    // 요청 전 후 FetchState에 대해서 값을 send합니다.
    input.fetchLiveDataPublisher
      .compactMap { [weak self] _ -> Void? in
        if self?.fetchStatePublisher.value == .running {
          return nil
        }
        self?.fetchStatePublisher.send(.running)
        return ()
      }
      .flatMap { [fetchUseCase] _ -> AnyPublisher<Void, Never> in
        return fetchUseCase.fetchLiveExchangingRate()
      }.sink { [weak self] _ in
        self?.fetchStatePublisher.send(.done)
      }.store(in: &subscriptions)

    // 타임스태프에 관해서 업데이트 하는 Publisher입니다
    let updateTimeStamp: ExchangingRateViewModelOutput = fetchUseCase.latestFetchedTime()
      .map { time in
        return ExchangingRateViewControllerState.updateTimeStamp(time: time)
      }.eraseToAnyPublisher()

    // 국가에 관한 정보를 전달하는 Publisher입니다.
    // UseCase로 받은 Publisher를 Transform하여 View에 맞는 객체를 전달합니다
    let updateCountry: ExchangingRateViewModelOutput = input.didSelectIndexPublisher
      .compactMap { [weak self, convertUseCase] row, text in
        guard
          let country = self?.countries[safe: row],
          let text
        else {
          return ExchangingRateViewControllerState.idle
        }
        self?.currentIndex = row

        let result = convertUseCase.applyQuote(text: text, quote: country.quote)
        self?.sendConvertedValuePublisher(with: result)

        let exchangingRateText = (convertUseCase.formattingQuote(country.quote) ?? "") + " " + country.unit + "/ USD"
        let property = ExchangingRateViewUpdatableProperty(receiveCountryText: country.name, exchangingRateText: exchangingRateText)
        return ExchangingRateViewControllerState.updateCountry(value: property)
      }
      .eraseToAnyPublisher()

    // TextField값이 전달 된다면, UseCase를 통해서 적절한 값을 전달하는 Pubilsher입니다

    input.textFieldTextPublisher
      .sink { [weak self] text in
        guard
          let self,
          let text,
          let quote = countries[safe: currentIndex]?.quote
        else {
          return
        }
        let result = convertUseCase.applyQuote(text: text, quote: quote)
        sendConvertedValuePublisher(with: result)
      }
      .store(in: &subscriptions)

    let idle = Just(ExchangingRateViewControllerState.idle)

    return idle.merge(with: updateCountry, updateTimeStamp, fetchState, convertedValuePublisher).eraseToAnyPublisher()
  }

  func sendConvertedValuePublisher(with result: ExchangingRateUseCaseOutput) {
    switch result {
    case let .success(string):
      let unit = countries[safe: currentIndex]?.unit ?? ""
      convertedValuePublisher.send(.updateExchangeConvertedText(value: string + unit))
    case .emptyInput:
      convertedValuePublisher.send(.emptyTextField)
    case .invalidInput:
      convertedValuePublisher.send(.wrongTextFieldText)
    case .nowFetching:
      convertedValuePublisher.send(.fetch(.firstRunning))
    case .error:
      convertedValuePublisher.send(.wrongTextFieldText)
    }
  }

  func pickerTitle(index: Int) -> String? {
    return countries[safe: index]?.description
  }

  func countOfReceiveCountry() -> Int {
    return countries.count
  }
}
