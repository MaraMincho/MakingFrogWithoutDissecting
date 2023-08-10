//
//  WeatherListViewModel.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import Foundation


class WeatherListViewModel {
    private var weathers: [WeatherViewModel] = [] {
        didSet {
            saveCurrentWeathers()
        }
    }
    
    var loadInitalWeatherDelegate: LoadInitalWeatherDelegate?
    
    func saveCurrentWeathers() {
        let curWeatherResponseList: [WeatherResponse] = weathers.map{$0.weather}
        guard let data = try? JsonHelper.jsonEncoder.encode(curWeatherResponseList) else {return}
        UserDefaults.standard.set(data, forKey: ConstUnit.WeatherResponseKey)
    }
    
    
    func loadPrevWeathers() {
        if let data = UserDefaults.standard.object(forKey: ConstUnit.WeatherResponseKey) as? Data{
            if let prevWeathersResponses = try? JsonHelper.jsonDecoer.decode([WeatherResponse].self, from: data) {
                prevWeathersResponses.forEach{
                    weathers.append(WeatherViewModel(weather: $0))
                }
            }
        }
        var count = 0
        let curGroup = DispatchGroup()
        for ind in 0..<self.numOfCitys() {
            DispatchQueue.global().async(group: curGroup) { [weak self] in
                guard let curViewModel = self?.weatherViewModel(index: ind) else {return}
                self?.updateWeathersVM(weatherViewModel: curViewModel) { result in
                    switch result {
                    case .failure(let error) :
                        print(error)
                    case .success(let weatherVM) :
                        self?.weathers[ind] = weatherVM
                    }
                    count += 1
                }
            }
        }
        
        DispatchQueue.global().async { [weak self] in
            while true {
                sleep(1)
                if count == self?.weathers.count {
                    self?.loadInitalWeatherDelegate?.reloadTableViewData()
                    print("실행함")
                    return
                }
            }
        }
        
        
    }
    
    func updateWeathersVM(weatherViewModel: WeatherViewModel, completion: @escaping (Result<WeatherViewModel, Error>) -> ()){
        guard let url = ConstUnit.urlByCityTemperatureUnit(city: weatherViewModel.cityName, tempUnit: .celsius) else {return}
        let resource = Resource<WeatherResponse>(httpRequestType: .get, url: url)
        loadInitalWeatherDelegate?.loadWeatherData(resource: resource,completion: { result in
            switch result {
            case .failure(let error) :
                completion(.failure(error))
            case .success(let weatherViewModel):
                completion(.success(weatherViewModel))
            }
        })
    }
    
    init() {
        loadPrevWeathers()
    }
    
    func numOfCitys() -> Int{
        return weathers.count
    }
    
    func weatherViewModel(index at: Int) -> WeatherViewModel {
        return weathers[at]
    }
    
    func addWeatherViewModel(_ weatherVM: WeatherViewModel) {
        self.weathers.append(weatherVM)
    }
    func deleteViewModel(at index: Int) {
        _ = weathers.remove(at: index)
    }
}


struct WeatherViewModel {
    let weather: WeatherResponse
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
