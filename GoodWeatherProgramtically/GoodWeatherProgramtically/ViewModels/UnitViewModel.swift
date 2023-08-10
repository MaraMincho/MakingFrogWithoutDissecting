//
//  UnitViewModel.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import Foundation


struct UnitViewModel {
    private let unit = TemperatureUnit.allCases
    private var unitRawValueKoreanValueMap: [TemperatureUnit : String] = [.celsius: "섭씨", .fahrenheit: "화씨"]
    func numOfUnit() -> Int {
        return unit.count
    }
    func getUnitRawValue(index: Int) -> String {
        let curUnit = unit[index]
        return unitRawValueKoreanValueMap[curUnit] ?? ""
    }
}

//
//case celsius = "celsius"
//case fahrenheit = "fahrenheit"
