//
//  ViewController.swift
//  TIL_PhotoKitExample1
//
//  Created by MaraMincho on 2/13/24.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    setupLayout()
    bind()
  }
  
  let button: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("눌러서 사진 열기", for: .normal)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let tempImage: UIImageView = {
    let imageView = UIImageView()
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
 
  
  func bind() {
    let buttonAction: UIAction = .init { [weak self] action in
      self?.presentPHPicker()
    }
    button.addAction(buttonAction, for: .touchUpInside)
  }
  
  func setupLayout() {
    
    
    view.addSubview(button)
    button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
    view.addSubview(tempImage)
    tempImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    tempImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
    tempImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
  }
  
  func presentPHPicker() {
    var configuration = PHPickerConfiguration()
    configuration.selectionLimit = 1
    
    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self
    present(picker, animated: false)
  }

}
extension ViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    
    /// 고른 사진중에 제일 첫번째 사진을 선택합니다.
    let itemProvider = results.first?.itemProvider
    
    if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
      itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
        DispatchQueue.main.async {
          guard let self = self, let image = image as? UIImage else { return }
          self.tempImage.image = image
        }
      }
    } else {
      // TODO: Handle empty results or item provider not being able load UIImage
    }
    
    
  }
  
}

