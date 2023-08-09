//
//  String+Extensions.swift
//  GoodWeather
//
//  Created by MaraMincho on 2023/08/09.
//

import Foundation


extension String {
    func escaped() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
}
