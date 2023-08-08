//
//  Resource.swift
//  HotCoffeeProgramtically
//
//  Created by MaraMincho on 2023/08/08.
//

import Foundation

struct Resource<T: Codable> {
    var url: URL
    let data: Data? = nil
    var httpMethod: httpMethod = .get
}


enum httpMethod: String {
    case post = "POST"
    case get = "GET"
}

