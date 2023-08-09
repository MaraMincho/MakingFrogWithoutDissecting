//
//  Double+Extension.swift
//  GoodWeather
//
//  Created by MaraMincho on 2023/08/09.
//

import Foundation


extension Double {
    func formatAsDegree() -> String {
        return String(format: "%.0f°", self)
    }
}
