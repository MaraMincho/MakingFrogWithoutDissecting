//
//  AddWeatherCityViewController.swift
//  GoodWeather
//
//  Created by MaraMincho on 2023/08/09.
//

import Foundation
import UIKit


protocol AddWeatherDelegate {
    func addWeatherDidSave(vm: WeatherViewModel)
}



class AddWeatherCityViewController:UIViewController, AddWeatherDelegate {
    func addWeatherDidSave(vm: WeatherViewModel) {
        
    }
    
    var delegate: AddWeatherDelegate?
    @IBOutlet weak var cityNameTextField: UITextField!
    private var addWeatherVM = AddWeatherViewModel()
    
    
    @IBAction func saveCityButtonPressed() {
        self.dismiss(animated: true, completion: nil)
        if let city = cityNameTextField.text {
            addWeatherVM.addWeather(for: city) { (vm) in
                print(vm)
                self.delegate?.addWeatherDidSave(vm: vm)
            }
        }
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
