//
//  ExchangingRateUseCaseOutput.swift
//
//  Created by MaraMincho on 1/17/24.
//

import Foundation

/// UseCase의 Fetch이후에 관한 정보들을 나타내기 위해서 쓰입니다.
enum ExchangingRateUseCaseOutput {
  /// 성공했을 때입니다.
  ///
  /// 인풋값을 통해 계산된 값을 동봉합니다.
  case success(String)

  /// 만약 View에서 input이 아무것도 없을때 입니다.
  case emptyInput

  /// Input이 잘못되었을 떄 입니다.
  case invalidInput

  /// 현재 Network통신중입니다.
  case nowFetching

  /// Network에서 발생한 에러 입니다.
  case error
}
