//
//  SceneDelegate.swift
//  TIL_CoreData
//
//  Created by MaraMincho on 2/6/24.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = .init(windowScene: windowScene)
    window?.rootViewController = ViewController()
    window?.makeKeyAndVisible()
  }

 
}
