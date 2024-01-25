//
//  ExchangingRateDTO.swift
//
//  Created by MaraMincho on 1/18/24.
//

import Foundation

struct ExchangingRateDTO: Decodable {
  let success: Bool
  let timestamp: Int
  let quotes: [String: Double]
}
