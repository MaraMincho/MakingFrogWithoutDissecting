//
//  UserTemperatureSettingViewModel.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import Foundation

struct UserTemperatureViewModel {
    var userTemperatureUnit: TemperatureUnit!
    init() {
        self.userTemperatureUnit = self.getUserTemperatureUnit()
    }
    
    private func getUserTemperatureUnit() -> TemperatureUnit {
        if let data = UserDefaults.standard.object(forKey: ConstUnit.temperatureUnitKey) as? Data {
            if let curType = try? JsonHelper.jsonDecoer.decode(TemperatureUnit.self, from: data) {
                return curType
            }
        }
        return .celsius
    }
    
    func saveUserTemperatureUnitType(tempType: TemperatureUnit) {
        guard let data = try? JsonHelper.jsonEncoder.encode(tempType) else {return}
        UserDefaults.standard.set(data, forKey: ConstUnit.temperatureUnitKey)
    }
    
}
