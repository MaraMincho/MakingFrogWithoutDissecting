//
//  Order.swift
//  HotCoffeeProgramtically
//
//  Created by MaraMincho on 2023/08/08.
//

import Foundation
enum CoffeeType:Codable {
    case capuccino
    case americano
    case gogumaLatte
    case latte
    case chickenLatte
    case blackBeanLatte
}

enum CoffeeSize:Codable {
    case venti
    case medium
    case tall
}

struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
}
