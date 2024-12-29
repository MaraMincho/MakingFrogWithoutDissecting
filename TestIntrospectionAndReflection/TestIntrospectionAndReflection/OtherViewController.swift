//
//  OtherViewController.swift
//  TestIntrospectionAndReflection
//
//  Created by MaraMincho on 12/29/24.
//

import UIKit

@objcMembers class OtherViewController: UIViewController {

    // MARK: - Properties
    var data: String = "Default Data"

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }

    // MARK: - Dynamic Method
  @objc private func dynamicMethod(_ argument: String) {
    print("2️⃣ \(Self.self)")
    print("dynamicMethod called with argument: \(argument)")
    print("Current data property: \(data)")
  }
}
