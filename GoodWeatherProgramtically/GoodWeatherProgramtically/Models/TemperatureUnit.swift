//
//  Unit.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import Foundation


enum TemperatureUnit: String, CaseIterable, Codable {
    case celsius = "celsius"
    case fahrenheit = "fahrenheit"
    
    var apiCallString: String {
        switch self {
        case .celsius :
            return "metric"
        case .fahrenheit :
            return "imperial"
        }
    }
}
