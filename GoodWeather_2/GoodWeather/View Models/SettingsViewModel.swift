//
//  SettingsViewModel.swift
//  GoodWeather
//
//  Created by MaraMincho on 2023/08/09.
//  Copyright © 2023 Mohammad Azam. All rights reserved.
//

import Foundation

enum Unit: String, CaseIterable, Codable {
    case celsius = "matric"
    case fahrenheit = "imperial"
}

extension Unit {
    var displayName: String {
        get {
            switch(self) {
            case .celsius :
                return "Celcius"
            case .fahrenheit :
                return "Fahrenheit"
            }
        }
    }
}

class SettingsViewModel {
    
    let units = Unit.allCases
    
    
    var selectedUnit: Unit {
        get {
            var unitValue = ""
            if let savedData = UserDefaults.standard.object(forKey: "unit") as? Data {
                if let curUnit = try? JSONDecoder().decode(Unit.self, from: savedData) {
                    unitValue = curUnit.rawValue
                }
            }
            return Unit(rawValue: unitValue) ?? .celsius
        }
        set {
            if let newData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.setValue(newData, forKey: "unit")
            }
            
        }
    }
}
