//
//  SceneDelegate.swift
//  QueenFisher
//
//  Created by MaraMincho on 1/25/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = .init(windowScene: windowScene)
    window?.rootViewController = ViewController()
    window?.makeKeyAndVisible()
  }
}

