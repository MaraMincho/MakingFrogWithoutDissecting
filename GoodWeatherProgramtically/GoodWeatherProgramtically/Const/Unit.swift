//
//  Unit.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import Foundation


enum ConstUnit {
    static func urlByCityTemperatureUnit(city: String, tempUnit: TemperatureUnit) -> URL?{
        let curTempUnitString = tempUnit.apiCallString
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=ef0fd9866ca027e0dca474cee84c53be&units=\(curTempUnitString)")!
    }
    static let temperatureUnitKey = "TemperatureUnitKey"
    static let WeatherResponseKey = "WeatherResponseKey"
}
