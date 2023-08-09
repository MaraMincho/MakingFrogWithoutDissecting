//
//  String+Extensions.swift
//  GoodWeather
//
//  Created by Mohammad Azam on 3/3/21.
//  Copyright © 2021 Mohammad Azam. All rights reserved.
//

import Foundation

extension String {
    
    func escaped() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
    
}
