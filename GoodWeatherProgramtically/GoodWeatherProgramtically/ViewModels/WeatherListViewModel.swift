//
//  WeatherListViewModel.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import Foundation


struct WeatherListViewModel {
    private var weathers: [WeatherViewModel] = []
    
    func numOfCitys() -> Int{
        return weathers.count
    }
    
    func weatherViewModel(index at: Int) -> WeatherViewModel {
        return weathers[at]
    }
    
    mutating func addWeatherViewModel(_ weatherVM: WeatherViewModel) {
        self.weathers.append(weatherVM)
    }
}


struct WeatherViewModel {
    private let weather: WeatherResponse
    init(weather: WeatherResponse) {
        self.weather = weather
    }
    var cityName: String {
        get {
            return weather.name
        }
    }
    var degree: Double {
        get {
            return weather.main.temp
        }
    }
}
