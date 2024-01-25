//
//  ViewController.swift
//  QueenFisher
//
//  Created by MaraMincho on 1/25/24.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
  
  let someImageView: UIImageView = {
    let imageView = UIImageView()
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupStyle()
  }
  
  
  func setupStyle() {
    view.backgroundColor = .white
    
    view.addSubview(someImageView)
    
  }
}
