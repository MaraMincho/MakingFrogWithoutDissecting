//
//  ExchangingRateConvertUseCase.swift
//
//  Created by MaraMincho on 1/17/24.
//

import Combine
import Foundation

// MARK: - ExchangingRateConvertUseCaseRepresentable

protocol ExchangingRateConvertUseCaseRepresentable {
  func formattingQuote(_ val: Double?) -> String?
  func applyQuote(text: String, quote: Double?) -> ExchangingRateUseCaseOutput
}

// MARK: - ExchangingRateConvertUseCase

final class ExchangingRateConvertUseCase {
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

  init() {}
}

// MARK: ExchangingRateConvertUseCaseRepresentable

extension ExchangingRateConvertUseCase: ExchangingRateConvertUseCaseRepresentable {
  func formattingQuote(_ val: Double?) -> String? {
    guard let val else { return nil }
    return numberFormatter.string(for: val)
  }

  func applyQuote(text: String, quote: Double?) -> ExchangingRateUseCaseOutput {
    guard let quote else {
      return .nowFetching
    }

    if text == "" {
      return .emptyInput
    }

    guard let convertedValue = Double(text) else {
      return .invalidInput
    }

    if convertedValue < 0 || convertedValue > 100_000 {
      return .invalidInput
    }

    guard let resString = numberFormatter.string(for: quote * convertedValue) else {
      return .invalidInput
    }

    return .success(resString)
  }
}
