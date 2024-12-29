//
//  MyClass.swift
//  TestIntrospectionAndReflection
//
//  Created by MaraMincho on 12/29/24.
//

import Foundation

class MyClass {
  private let privateUUID: String = UUID().uuidString
  private let name: String
  private static var staticProperty: String = "Initial Static Value"

  init(name: String) {
    self.name = name
  }
}
