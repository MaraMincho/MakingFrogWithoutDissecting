//
//  ExchangingRateRepositoryRepresntable.swift
//
//  Created by MaraMincho on 1/17/24.
//

import Combine
import Foundation

protocol ExchangingRateRepositoryRepresentable {
  func fetchLiveExchangingRate(targetCountryUnit: [String]) -> AnyPublisher<ExchangingRateDTO, Error>
}
