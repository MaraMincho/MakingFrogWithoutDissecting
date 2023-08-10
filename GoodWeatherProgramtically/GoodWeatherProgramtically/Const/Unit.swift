//
//  Unit.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import Foundation


enum ConstUnit {
    static func urlByCityTemperatureUnit(city: String) -> URL?{
        let curTempUnitString = TemperatureUnit.celsius.apiCallString
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=4941418c74d04be14deb3f49b9718d63&units=\(curTempUnitString)")!
    }
    static let temperatureUnitKey = "TemperatureUnitKey"
    static let WeatherResponseKey = "WeatherResponseKey"
}
