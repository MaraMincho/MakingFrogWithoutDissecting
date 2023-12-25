//
//  HomeDIContainer.swift
//  DIContainer
//
//  Created by MaraMincho on 11/6/23.
//  Copyright © 2023 MaraMincho. All rights reserved.
//

import Foundation
import Home
import HomeViewModel

final class HomeDIContainer {
  
  static let shared = HomeDIContainer()
  
  private var dependencies: [String: Any] = .init()
  
  private init () {}
  
  func register<T>(dependency: T){
    let key = String(describing: type(of: T.self))
    dependencies[key] = dependency
  }
  
  func resolve<T>() -> T? {
    let key = String(describing: type(of: T.self))
    return dependencies[key] as? T
  }
}

protocol HomeDIContainerProtocol: DIContainer {
  func presentHomeViewController() -> HomeViewController
}
