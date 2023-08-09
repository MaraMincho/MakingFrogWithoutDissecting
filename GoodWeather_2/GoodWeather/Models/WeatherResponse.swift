//
//  WeatherResponse.swift
//  GoodWeather
//
//  Created by Mohammad Azam on 9/3/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
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
