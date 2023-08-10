//
//  WeatherResponse.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import Foundation

struct WeatherResponse: Codable {
    var name: String
    var main: Weather
}

struct Weather: Codable {
    var temp: Double
    let humidity: Double
}
