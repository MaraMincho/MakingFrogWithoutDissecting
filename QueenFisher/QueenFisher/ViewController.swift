//
//  ViewController.swift
//  QueenFisher
//
//  Created by MaraMincho on 1/25/24.
//

import Combine
import Kingfisher
import UIKit

class ViewController: UIViewController {
  var subscription = Set<AnyCancellable>()
  let someImageView: UIImageView = {
    let imageView = UIImageView()
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let timerLabel: UILabel = {
    let label = UILabel()
    label.text = "하이용"
    
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupStyle()
    bindTimer()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupImage()
  }
  
  func bindTimer() {
    Timer.publish(every: 0.1, on: .main, in: .common)
      .autoconnect()
      .sink { val in
        self.timerLabel.text = val.description
      }
      .store(in: &subscription)
  }
  
  func setupImage() {
    let urlString = "https://upload.wikimedia.org/wikipedia/commons/2/21/%221ere_feuille_particuli%C3%A8re_du_Thibet%22_%28mention_ms%29_-_%28Anville%29_%3B_Deshulins_sculp._-_btv1b8491979b.jpg"
    let url = URL(string: urlString)!
    someImageView.image = downsample(imageAt: url, to: someImageView.bounds.size, scale: 1)
  }
  
  private func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage {
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
    let queue = DispatchQueue.global(qos: <#T##DispatchQoS.QoSClass#>)
    
    let maxDimentionInPixels = max(pointSize.width, pointSize.height) * scale
    
    let downsampledOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: maxDimentionInPixels,
    ] as CFDictionary
    
    let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampledOptions)!
    
    return UIImage(cgImage: downsampledImage)
  }
  
  func setupStyle() {
    view.backgroundColor = .white
    let safeArea = view.safeAreaLayoutGuide
    
    view.addSubview(timerLabel)
    timerLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60).isActive = true
    timerLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    
    view.addSubview(someImageView)
    someImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 120).isActive = true
    someImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    someImageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    someImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
  }
}
