//
//  ViewController.swift
//  QueenFisher
//
//  Created by MaraMincho on 1/25/24.
//

import UIKit
import Kingfisher
import Combine

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
    setupImage()
    bindTimer()
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
    let url = URL(string: urlString)
    let imageData = try! Data(contentsOf: url!)
    someImageView.image = .init(data: imageData)
  }
  
  func downSampling(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage {
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!

    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
    let downSamplingOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
    ] as CFDictionary

    let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSamplingOptions)!

    return UIImage(cgImage: downSampledImage)
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
