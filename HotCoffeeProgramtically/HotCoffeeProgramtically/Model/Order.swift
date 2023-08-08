//
//  Order.swift
//  HotCoffeeProgramtically
//
//  Created by MaraMincho on 2023/08/08.
//

import Foundation
enum CoffeeType:String, Codable, CaseIterable {
    case cappucino
    case latte
    case americano
    case espresso
    case cortado
    case gogumaLatte
}

enum CoffeeSize:String, Codable, CaseIterable {
    case small
    case medium
    case large
}

struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
}
