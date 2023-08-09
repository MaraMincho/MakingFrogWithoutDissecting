//
//  Constants.swift
//  GoodWeather
//
//  Created by MaraMincho on 2023/08/09.
//

import Foundation


struct Constants {
    struct URLs {
        static func urlForWatherByCity(city: String) -> URL {
            return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city.escaped())&appid=4941418c74d04be14deb3f49b9718d63")!
        }
    }
}
