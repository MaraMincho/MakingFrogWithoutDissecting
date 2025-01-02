//
//  main.swift
//  Test
//
//  Created by MaraMincho on 1/2/25.
//

import Foundation
func getLocalizedMonthAbbreviation(month: Int, locale: Locale) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M"
    dateFormatter.locale = locale

    // 주어진 월을 기반으로 날짜 생성
    let calendar = Calendar.current
    var components = DateComponents()
    components.month = month
    components.year = 2000 // 임의의 연도
    components.day = 1 // 임의의 날짜

    guard let date = calendar.date(from: components) else { return nil }

    // 현지화된 월 출력
    dateFormatter.dateFormat = "MMM"
    return dateFormatter.string(from: date)
}

// 테스트
let englishLocale = Locale(identifier: "en_US")
let koreanLocale = Locale(identifier: "ko_KR")
let japanLocal = Locale(identifier: "ja_JP")

(1...12).forEach { ind in
  if let englishMonth = getLocalizedMonthAbbreviation(month: ind, locale: englishLocale) {
      print("English: \(englishMonth)") // May
  }

  if let koreanMonth = getLocalizedMonthAbbreviation(month: ind, locale: koreanLocale) {
      print("Korean: \(koreanMonth)") // 5월
  }

  if let japanMonth = getLocalizedMonthAbbreviation(month: ind, locale: japanLocal) {
      print("Korean: \(japanMonth)") // 5월
  }

}

