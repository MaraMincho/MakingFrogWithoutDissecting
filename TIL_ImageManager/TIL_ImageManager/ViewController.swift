//
//  ViewController.swift
//  TIL_ImageManager
//
//  Created by MaraMincho on 2/11/24.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
  
  deinit {
    print(Self.self, "deinit")
  }

  private var imageView: UIImageView = {
    let imageView = UIImageView()
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private let downSampledImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
  }()
  
  private lazy var imageStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      imageView,
      downSampledImageView
    ])
    stackView.axis = .horizontal
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let targetButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("눌러눌러눌러눌러", for: .normal)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let secondButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("눌러눌러눌러눌러", for: .normal)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    
    view.backgroundColor = .white
    
    let safeArea = view.safeAreaLayoutGuide
    view.addSubview(imageStackView)
    imageStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    imageStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
    
    imageView.backgroundColor = .red
    imageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    
    imageView.backgroundColor = .blue
    downSampledImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
    downSampledImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    
    view.addSubview(targetButton)
    targetButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
    targetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    view.addSubview(secondButton)
    secondButton.topAnchor.constraint(equalTo: targetButton.bottomAnchor, constant: 30).isActive = true
    secondButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    targetButton.addTarget(self, action: #selector(someAction), for: .touchUpInside)
    secondButton.addTarget(self, action: #selector(twoAction), for: .touchUpInside)
  }
  
  @objc func someAction() {
    self.present(ViewController(), animated: true)
  }
  @objc func twoAction() {
    print(imageView.fetchStatus() ?? "")
  }
  
  func setupView() {
    imageView.setImage(url: URL(string: "https://w7.pngwing.com/pngs/151/483/png-transparent-brown-tabby-cat-cat-dog-kitten-pet-sitting-the-waving-cat-animals-cat-like-mammal-pet-thumbnail.png"))
    imageView.TempAssociatedObject = SomeClass()
    imageView.kf.setImage(with: <#T##Source?#>)
  }
}

extension UIImageView {
  private enum AssociatedKeys {
      static var intKey = "lastOffsetY"
  }
  var TempAssociatedObject: SomeClass {
    get {
      objc_getAssociatedObject(self, AssociatedKeys.intKey) as? SomeClass ?? SomeClass()
    }
    set {
      objc_setAssociatedObject(self, AssociatedKeys.intKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

final class SomeClass {
  deinit {
    print("나 디이닛 해용 \(Self.self)")
  }
}
