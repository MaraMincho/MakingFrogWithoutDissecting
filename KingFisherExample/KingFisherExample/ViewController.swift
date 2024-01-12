//
//  ViewController.swift
//  KingFisherExample
//
//  Created by MaraMincho on 1/3/24.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
  private lazy var testImageView: UIImageView = {
    let imageView = UIImageView()
    let url = URL(string:"https://upload.wikimedia.org/wikipedia/commons/2/21/%221ere_feuille_particuli%C3%A8re_du_Thibet%22_%28mention_ms%29_-_%28Anville%29_%3B_Deshulins_sculp._-_btv1b8491979b.jpg")
    imageView.kf.indicatorType = .activity
    let what = imageView.kf.setImage(
      with: url,
      options: [.transition(.fade(2)), .cacheMemoryOnly, .forceTransition]
    )
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setup()
  }
  
  func setup() {
    configureViewHierarchyAndConstraints()
  }
  func configureViewHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    
    view.addSubview(testImageView)
    testImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30).isActive = true
    testImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15).isActive = true
    testImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15).isActive = true
    testImageView.heightAnchor.constraint(equalToConstant: 350).isActive = true
  }
}

