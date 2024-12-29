//
//  ViewController.swift
//  TestIntrospectionAndReflection
//
//  Created by MaraMincho on 12/29/24.
//

import UIKit

class MyViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white

    view.addSubview(myButton)
    myButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    myButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    myButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
    myButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
    myButton.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let myClass = MyClass(name: "initialized by MyViewController at viewDidAppear")
    reflectAndModifyUsingPointer(instance: myClass)
  }

  private let myButton: UIButton = {
    let button = UIButton()
    button.setTitle("tap Button", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = UIColor.blue

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  // MARK: - Action
  @objc func handleButtonTap() {
    print("1️⃣ \(Self.self)")
    print("Button tapped! Now invoking OtherViewController via Reflection.")

    // MyViewController에서 호출
    let className = "\(Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "").OtherViewController"
    let targetClass = NSClassFromString(className) as! UIViewController.Type

    // Step 2: Instantiate OtherViewController
    let targetInstance = targetClass.init()

    // Step 3: Set a dynamic property on OtherViewController
    targetInstance.setValue("Reflection works!", forKey: "data")

    // Step 4: Dynamically call a method on OtherViewController
    let selectorName = "dynamicMethod:"
    let selector = NSSelectorFromString(selectorName)

    if targetInstance.responds(to: selector) {
      targetInstance.perform(selector, with: "Hello from MyViewController!")
    } else {
      print("Error: Selector '\(selectorName)' not found in \(className).")
    }
  }

  private func reflectAndModifyUsingPointer(instance: AnyObject) {
    let mirror = Mirror(reflecting: instance)

    print("Before modification:")
    for child in mirror.children {
      if let propertyName = child.label {
        print("\(propertyName): \(child.value)")
      }
    }

    // UnsafeMutablePointer를 사용해 런타임 "name" 속성 값 변경
    if let nameOffset = class_getInstanceVariable(type(of: instance), "name") { // ✅ 포인터 접근
      let pointer = unsafeBitCast(instance, to: UnsafeMutableRawPointer.self)
      let offsetPointer = pointer.advanced(by: ivar_getOffset(nameOffset))
      offsetPointer.assumingMemoryBound(to: String.self).pointee = "Modified Value"
    }

    // UnsafeMutablePointer를 사용해 런타임 "privateUUID" 속성 값 변경
    if let nameOffset = class_getInstanceVariable(type(of: instance), "privateUUID") { // ✅ 포인터 접근
      let pointer = unsafeBitCast(instance, to: UnsafeMutableRawPointer.self)
      let offsetPointer = pointer.advanced(by: ivar_getOffset(nameOffset))
      offsetPointer.assumingMemoryBound(to: String.self).pointee = "Modified Value + \(UUID().uuidString)"
    }

    print("\nAfter modification:")
    for child in mirror.children {
      if let propertyName = child.label {
        print("\(propertyName): \(child.value)")
      }
    }
  }

  @objc
  private func buttonTapped() {
    print("MyViewController tapped")
  }
}

