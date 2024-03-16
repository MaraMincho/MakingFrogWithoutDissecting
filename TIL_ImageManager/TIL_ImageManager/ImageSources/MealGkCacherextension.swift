//
//  MealGkCacherExtenstion.swift
//  TIL_ImageManager
//
//  Created by MaraMincho on 2/21/24.
//

import UIKit


extension UIImageView: MealGokCacherWrapper {
  func setImage(with url: URL) {
    base.setImage(url: url) { result in
      switch result {
      case let .success(image):
        self.image = image
      case .failure(let failure):
        break
      }
    }
  }
}
protocol MealGokCacherWrapper {
  
}
private struct MealGokCacherWrapperPropertyKey {
  static let key = "MealGokCacherWrapperPropertyKey"
}
extension MealGokCacherWrapper {
  var base: MealGokCacherWrapperProperty {
    get {
      objc_getAssociatedObject(self, MealGokCacherWrapperPropertyKey.key) as? MealGokCacherWrapperProperty ?? MealGokCacherWrapperProperty()
    }
    set {
      objc_setAssociatedObject(self, MealGokCacherWrapperPropertyKey.key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}
final class MealGokCacherWrapperProperty {
  func setImage(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
    // 내부 파일 체크
    // 메모리 체크
    
  }
  func fetchImageFromNetwork(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      <#code#>
    }
  }
}
