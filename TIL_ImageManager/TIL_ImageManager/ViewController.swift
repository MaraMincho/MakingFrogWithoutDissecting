//
//  ViewController.swift
//  TIL_ImageManager
//
//  Created by MaraMincho on 2/11/24.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

  private let imageView:UIImageView = {
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
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    
    setupView()
  }
  
  func setupView() {
    imageView.kf.setImage(with: <#T##Source?#>, options: <#T##KingfisherOptionsInfo?#>)
    imageView.setImage(url: URL(string: "https://w7.pngwing.com/pngs/151/483/png-transparent-brown-tabby-cat-cat-dog-kitten-pet-sitting-the-waving-cat-animals-cat-like-mammal-pet-thumbnail.png"))
  }

}

final class FileCacher {
  private enum ImageFileManagerProperty{
    static let documentPath = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first!
    static let imageDirPath = documentPath.appending(path: ImageCacherConstants.dirName)
    static let fileManger = FileManager.default
  }
  
  private enum ImageNetworkProperty {
    static let imageSession: URLSession = .init(configuration: .default)
  }
  private enum ImageCacherConstants {
    static let dirName: String = "Images"
  }
  public enum FileCacherError: LocalizedError {
    case noData
  }
  
  
  /// LoadImageData
  /// - Parameters:
  ///   - url: URL
  ///   - completion: Network data
  /// - Returns: DataTask if image in cache return nil
  @discardableResult
  static func load(url: URL, completion: @escaping (Data?) -> Void) -> URLSessionDataTask?{
    
    /// 파일지 저장될 URL입니다.
    let imagePathURL = ImageFileManagerProperty.imageDirPath.appending(path: url.lastPathComponent)
    
    if isExistImageDirectory(url: imagePathURL) {
      completion(try! Data(contentsOf: imagePathURL))
      return nil
    }else {
      return loadImage(url: url) { data in
        if let data {
          try! data.write(to: imagePathURL, options: .atomic)
        }
        completion(data)
      }
    }
  }
  
  private static func isExistImageDirectory(url: URL) -> Bool{
    let fileManager = ImageFileManagerProperty.fileManger
    if fileManager.fileExists(atPath: ImageFileManagerProperty.imageDirPath.path()) == false {
      try! fileManager.createDirectory(at: ImageFileManagerProperty.imageDirPath, withIntermediateDirectories: true)
    }
    return fileManager.fileExists(atPath: url.path())
  }
  
  /// 에러를 처리할 수 있는 분기가 있으면 좋을 듯
  private static func loadImage(url: URL, completion: @escaping (Data?) -> Void) -> URLSessionDataTask {
    let session = ImageNetworkProperty.imageSession
    let task = session.dataTask(with: URLRequest(url: url)) { data, response, error in
      completion(data)
    }
    task.resume()
    return task
  }
}

extension UIImageView {
  private enum LoadImageProperty {
    static let queue = DispatchSerialQueue(label: "ImageQueue")
  }
  
  @discardableResult
  func setImage(url: URL?) -> URLSessionDataTask? {
    guard let url = url else {
      return nil
    }
    return FileCacher.load(url: url) { data in
      
      DispatchQueue.main.async {
        self.image = UIImage(data: data!)
      }
    }
  }

}
