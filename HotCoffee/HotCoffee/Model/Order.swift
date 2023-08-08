//
//  Order.swift
//  HotCoffee
//
//  Created by MaraMincho on 2023/08/07.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable {
    case cappucino
    case latte
    case americano
    case espresso
    case cortado
    case gogumaLatte
}


enum CoffeesSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}


struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeesSize
}

extension Order {
    
    static var all: Resource<[Order]> = {
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders")else {
            fatalError("URL is Wrong")
        }
        return Resource<[Order]>(url: url)
    }()
    
    static func create(vm: AddCoffeeOrderViewModel) -> Resource<Order?> {
        let order = Order(vm)
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders")else {
            fatalError("URL is Wrong")
        }
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Encoding Error")
        }
        let resource = Resource<Order?>(url: url, httpMethod: .post, body: data)
        
        return resource
    }
    
    
    init?(_ vm: AddCoffeeOrderViewModel) {
        guard let name = vm.name,
              let email = vm.email,
              let selectedType = CoffeeType(rawValue: vm.selectedType!.lowercased()),
              let selectedSize = CoffeesSize(rawValue: vm.selectedSize!.lowercased())
        else {
            return nil
        }
        self.name = name
        self.email = email
        self.type = selectedType
        self.size = selectedSize
    }
}
