//
//  WeatherStatusViewController.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import UIKit

class WeatherStatusViewController: UIViewController {
    var weatherStatusView: WeatherStatusView!
    
    override func loadView() {
        super.loadView()
        let view = WeatherStatusView()
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

extension WeatherStatusViewController {
    @objc func presentAddCityScreen() {
        let nextVC = AddCityViewController()
        nextVC.loadViewIfNeeded()
        present(nextVC, animated: true)
    }
    
    @objc func presentSettingScreen() {
        let nextVC = SetTemperatureUnitViewController()
        nextVC.loadViewIfNeeded()
        present(nextVC, animated: true)
    }
}
