//
//  SceneDelegate.swift
//  TS_CoordinatorRetainCycle
//
//  Created by MaraMincho on 2/2/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var nav: UINavigationController?
  var rootCoordinator: RootCoordinator?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let tabBar = UITabBarController()
    tabBar.viewControllers = [UINavigationController(rootViewController: ViewController())]
    let nav = UINavigationController(rootViewController: tabBar)
    
    
    window = .init(windowScene: windowScene)
    window?.rootViewController = nav
    self.nav = nav
    rootCoordinator = .init(parent: nil, navigationController: nav, window: window)
    window?.rootViewController = nav
    window?.makeKeyAndVisible()
    
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) {
      let vc = ViewController()
      vc.view.backgroundColor = .red
      let nav = UINavigationController(rootViewController: vc)
      self.nav = nav
      self.rootCoordinator = .init(parent: nil, navigationController: nav, window: self.window)
      self.window?.rootViewController = nav
      self.rootCoordinator?.start()

    }
    window?.makeKeyAndVisible()
  }

}

final class RootCoordinator: Coordinating {
  func start() {
    let viewController = ViewController()
    
    navigationController?.setViewControllers([viewController], animated: true)
  }
  
  weak var parent: Coordinating?
  
  var navigationController: UINavigationController?
  
  var childCoordinators: [Coordinating] = []
  var window: UIWindow?
  
  init(parent: Coordinating?, navigationController: UINavigationController?, window: UIWindow?) {
    self.parent = parent
    self.navigationController = navigationController
    self.window = window
  }
  
  deinit {
    print(Self.self, "deinited")
  }
  
  func reset() {
    navigationController?.setViewControllers([UIViewController()], animated: true)
  }
}

