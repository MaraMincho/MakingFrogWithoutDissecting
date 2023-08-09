//
//  AddWeatherViewModel.swift
//  GoodWeather
//
//  Created by MaraMincho on 2023/08/09.
//

import Foundation


class AddWeatherViewModel {
    func addWeather(for city: String, completion: @escaping (WeatherViewModel) -> Void) {
        
        let watherURL = Constants.URLs.urlForWatherByCity(city: city)
        
        let weatherResource = Resource<WeatherResponse>(url: watherURL) { data in
            let watherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
            return watherResponse
        }
        Webservice().load(resource: weatherResource) { (result) in
            if let weatherResource = result {
                let vm = WeatherViewModel(weather: weatherResource)
                completion(vm)
            }
        }
    }
    
}
