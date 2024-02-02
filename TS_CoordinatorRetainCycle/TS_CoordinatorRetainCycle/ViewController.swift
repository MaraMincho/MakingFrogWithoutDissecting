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
    view.backgroundColor = .white
  }
  
  weak var router: RootCoordinator?
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  deinit {
    print(Self.self, "deinited")
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
}

extension Coordinating {
  func pop(flow: Flow) {
    childCoordinators.forEach { child in
      child.pop(flow: flow)
    }
    let notProfileFlowChild = childCoordinators.filter{$0 !== self}
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
