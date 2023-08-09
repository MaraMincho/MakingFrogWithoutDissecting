//
//  Constants.swift
//  GoodWeather
//
//  Created by Mohammad Azam on 3/3/21.
//  Copyright © 2021 Mohammad Azam. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Urls {
        
        static func urlForWeatherByCity(city: String) -> URL {
            
            // get the default settings for temperature
            let userDefaults = UserDefaults.standard
            var unit = Unit.fahrenheit
            if let curData = userDefaults.object(forKey: "unit") as? Data{
                if let curUnit = try? JSONDecoder().decode(Unit.self, from: curData) {
                    unit = curUnit
                }
            }
            
            print(unit)
            return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city.escaped())&appid=ef0fd9866ca027e0dca474cee84c53be&units=\(unit)")!
        }
        
    }
    
}
