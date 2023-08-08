//
//  AddCoffeeViewModel.swift
//  HotCoffeeProgramtically
//
//  Created by MaraMincho on 2023/08/08.
//

import Foundation

struct AddCoffeeOrderViewModel {
    
    var name: String?
    var email: String?
    
    var selectedType: String?
    var selectedSize: String?
    
    var types: [String] {
        return CoffeeType.allCases.map{$0.rawValue}
    }
    
    var sizes: [String] {
        return CoffeeSize.allCases.map{$0.rawValue}
    }
}
