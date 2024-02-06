//
//  ViewController.swift
//  TIL_CoreData
//
//  Created by MaraMincho on 2/6/24.
//

import UIKit
import OSLog

class ViewController: UIViewController {

  let manager = CoreDataManager.shared
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    manager.saveUsers(id: 2, name: "asdaf", age: 20, date: .now, devices: ["아아폰 2"]) { bool in }
    manager.saveUsers(id: 1, name: "asdf", age: 20, date: .now, devices: ["아아폰 3"]) { bool in }
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Logger().debug("디버그 내용입니다. \(self.manager.getUsers().map{$0.devices})")
  }
}

