//
//  ViewController.swift
//  TS_CoordinatorRetainCycle
//
//  Created by MaraMincho on 2/2/24.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }


}


enum Flow {
  case profile
  case home
  case writing
  case tabBar
  case feed
}

protocol Coordinating: AnyObject {
  func start()
  var parent: Coordinating? { get }
  var navigationController: UINavigationController? { get }
  var childCoordinators: [Coordinating] { get set }
  var flow: Flow { get }
}

extension Coordinating {
  func pop(flow: Flow) {
    childCoordinators.forEach { child in
      child.pop(flow: flow)
    }
    let notProfileFlowChild = childCoordinators.filter{$0.flow != .profile}
    childCoordinators = notProfileFlowChild
  }
}

final class HomeCoordinator: Coordinating {
  let flow: Flow = . tabBar
  
  func start() {
    navigationController?.pushViewController(makeTapBarController(), animated: false)
  }
  func makeTapBarController() -> UITabBarController {
    return .init()
  }
  
  weak var parent: Coordinating?
  
  weak var navigationController: UINavigationController?
  
  var childCoordinators: [Coordinating] = []
  
  init(parent: Coordinating, navigationController: UINavigationController) {
    self.parent = parent
    self.navigationController = navigationController
  }
}

extension HomeCoordinator {
  func removeFeedFlow() {
    pop(flow: .feed)
    navigationController?.popToRootViewController(animated: true)
  }
}
