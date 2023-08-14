//
//  UserModel.swift
//  NetwrokingExample
//
//  Created by MaraMincho on 2023/08/14.
//

import Foundation


struct User: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
