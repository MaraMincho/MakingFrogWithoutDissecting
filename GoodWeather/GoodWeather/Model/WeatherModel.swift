//
//  WeatherModel.swift
//  GoodWeather
//
//  Created by MaraMincho on 2023/08/09.
//

import Foundation



struct WeatherResponse: Decodable {
    let name: String
    let main: Weather
}

struct Weather: Decodable {
    let temp: Double
    let humidity: Double
}
