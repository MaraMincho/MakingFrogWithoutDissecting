//
//  receiveCountry.swift
//  
//
//  Created by MaraMincho on 1/16/24.
//

import Foundation

struct ReceiveCountry: CustomStringConvertible {
  /// 국가 이름입니다.
  var name: String

  /// 국가 통화 영어 단위 입니다.
  var unit: String

  /// USD 당 얼마인지 계산한 금액 입니다.
  var quote: Double?

  /// pickerView에 표시될 Text임니다.
  var description: String { return "\(name)(\(unit))" }
}
