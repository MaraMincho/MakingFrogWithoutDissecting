//
//  WeatherStatusViewController.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import UIKit

class WeatherStatusViewController: UIViewController {
    var weatherStatusView: WeatherStatusView!
    let services = WeatherServices()
    
    
    // MARK: - 뷰를 추가한다.
    override func loadView() {
        super.loadView()
        let view = WeatherStatusView()
        let weatherListViewModel = WeatherListViewModel()
        
        view.weatherListVM = weatherListViewModel
        view.weatherListVM.loadInitalWeatherDelegate = self
        
        self.view = view
        self.weatherStatusView = view
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviagationController()
    }
    
    func setupNaviagationController() {
        self.navigationItem.title = "현재 각 국의 날씨입니다."
      
        setupSettingBarButtonItem()
        setupAddCityBarButtonItem()
    }
    
    
    private func setupSettingBarButtonItem() {
        let settingItem: UIBarButtonItem = {
            let item = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(presentSettingScreen))
            return item
        }()
        self.navigationItem.leftBarButtonItem = settingItem
    }
    
    
    private func setupAddCityBarButtonItem() {
        let addCitiyItem: UIBarButtonItem = {
            let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddCityScreen))
            return item
        }()
        self.navigationItem.rightBarButtonItem = addCitiyItem
    }

}

extension WeatherStatusViewController: UpdateWeatherListViewModelDelegate, LoadInitalWeatherDelegate {
    
    func updateCurrentViewModel(cityName: String) {
        let tempUnit = self.weatherStatusView.userTemperatureViewModel.userTemperatureUnit!
        guard let curURL = ConstUnit.urlByCityTemperatureUnit(city: cityName, tempUnit: tempUnit) else {
            return
        }
        let resource = Resource<WeatherResponse>(httpRequestType: .get, data: nil, url: curURL)
        
        services.load(resource: resource) { result in
            switch result {
            case .failure(let error) :
                print (error)
            case .success(let weatherResponse) :
                let weatherVM = WeatherViewModel(weather: weatherResponse)
                self.weatherStatusView.weatherListVM!.addWeatherViewModel(weatherVM)
                self.reloadTableViewData()
            }
        }
    }
    
    func reloadTableViewData() {
        DispatchQueue.main.async {
            self.weatherStatusView.tableView.reloadData()
        }
    }
    
    func loadWeatherData(resource: Resource<WeatherResponse>, completion: @escaping (Result<WeatherViewModel, Error>) -> ()){
        services.load(resource: resource) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let weatherResponse) :
                let weatherVM = WeatherViewModel(weather: weatherResponse)
                completion(.success(weatherVM))
            }
            
        }
    }
    
    
    @objc func presentAddCityScreen() {
        let nextVC = AddCityViewController()
        nextVC.updateWatherListVMDelegate = self
        
        nextVC.loadViewIfNeeded()
        present(nextVC, animated: true)
    }
    
    @objc func presentSettingScreen() {
        let nextVC = SetTemperatureUnitViewController()
        nextVC.loadViewIfNeeded()
        
        present(nextVC, animated: true)
    }
}

protocol UpdateWeatherListViewModelDelegate {
    func updateCurrentViewModel(cityName: String)
}

protocol LoadInitalWeatherDelegate {
    func loadWeatherData(resource: Resource<WeatherResponse>, completion: @escaping (Result<WeatherViewModel, Error>) -> ())
    func reloadTableViewData()
}
