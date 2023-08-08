//
//  OrderViewModel.swift
//  HotCoffeeProgramtically
//
//  Created by MaraMincho on 2023/08/08.
//

import Foundation

struct OrdersViewModel {
    private var orders: [OrderViewModel] = []
    func numOfOrders() -> Int {
        return orders.count
    }
    
    func currentOrder(index: Int) -> OrderViewModel{
        return orders[index]
    }
    init(orders:[Order]) {
        orders.forEach{self.orders.append(OrderViewModel(order: $0))}
    }
}

struct OrderViewModel {
    private let name: String
    private let email: String
    private let type: CoffeeType
    private let size: CoffeeSize
    
    init(order: Order) {
        self.name = order.name
        self.email = order.email
        self.type = order.type
        self.size = order.size
    }
    
    
    
    var titleLabelText: String {
        get {
            return self.type.rawValue
        }
    }
    var descriptionText: String {
        get {
            return self.size.rawValue
        }
    }
}
