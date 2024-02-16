import UIKit
import OSLog
import Combine

public final class FetchDescriptionProperty {
  private var fetchStatus: CurrentValueSubject<FetchManagerFetchStatus, Never>
  private weak var fetchSubscription: AnyCancellable?
  
  deinit {
    print(Self.self, "was deinit")
  }
  init(fetchStatus: CurrentValueSubject<FetchManagerFetchStatus, Never>, fetchSubscription: AnyCancellable?) {
    self.fetchStatus = fetchStatus
    self.fetchSubscription = fetchSubscription
  }
  
  /// 현재 fetchStatus를 리턴합니다.
  func currentFetchStatus() -> FetchManagerFetchStatus {
    return fetchStatus.value
  }
  
  /// fetchStatusPublisher를 리턴합니다.
  func fetchStatusPublisher() -> AnyPublisher<FetchManagerFetchStatus, Never> {
    return fetchStatus.eraseToAnyPublisher()
  }
  
  func cancelFetch() {
    fetchSubscription?.cancel()
  }
}

final class FetchManager {
  
  private enum LoadImageProperty {
    static let queue = DispatchConcurrentQueue(label: "ImageQueue")
  }
  private var subscription = Set<AnyCancellable>()
  
  
  func dataTask(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> FetchDescriptionProperty {
    let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: url)
    let fetchStatusPublisher: CurrentValueSubject<FetchManagerFetchStatus, Never> = .init(.fetching)
    
    let publisher = dataTaskPublisher
      .subscribe(on: LoadImageProperty.queue)
      .sink { complete in
        switch complete {
        case .finished :
          fetchStatusPublisher.send(.finished)
        case let .failure(error) :
          fetchStatusPublisher.send(.error(error))
          completion(.failure(error))
        }
    } receiveValue: { (data: Data, response: URLResponse) in
      completion(.success(data))
    }
    let property = FetchDescriptionProperty(fetchStatus: fetchStatusPublisher, fetchSubscription: publisher)
    
    
    publisher.store(in: &subscription)
    return property
  }
}
public enum FetchManagerFetchStatus {
  
  /// 아직 Fetch를 시작하지 않았습니다.
  ///
  /// URL을 Fetch하라는 명령이 있었는지 확인해 보세요
  case notStarted
  
  /// 현재 Fetch중입니다.
  case fetching
  
  /// Fetch가 끝났습니다.
  case finished
  
  /// Fetch중 에러가 발생했습니다.
  case error(Error)
}

public final class FileCacher {
  
  private init () { }
  static let shared = FileCacher()
  
  //MARK: - Property
  var targetViewAndFetchProperty: NSMapTable<UIImageView, FetchDescriptionProperty> = .weakToStrongObjects()
  
  enum ImageFileManagerProperty{
    static let documentPath = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first!
    static let imageDirPath = documentPath.appending(path: ImageCacherConstants.dirName)
    static let fileManger = FileManager.default
    static let fetchManager = FetchManager()
  }
  
  private enum ImageNetworkProperty {
    static let imageSession: URLSession = .init(configuration: .default)
  }
  
  private enum ImageCacherConstants {
    static let dirName: String = "MealGokImages"
  }
  
  public enum FileCacherError: LocalizedError {
    case noData
    case invalidURL
  }

  /// LoadImageData
  /// - Parameters:
  ///   - url: URL
  ///   - completion: Network data
  /// - Returns: DataTask if image in cache return nil
  public static func loadImage(url: URL?, target: UIImageView, completion: @escaping (Result<Data, Error>) -> Void){
    guard let url else {
      completion(.failure(FileCacherError.invalidURL))
      return
    }
    let imagePathURL = ImageFileManagerProperty.imageDirPath.appending(path: url.lastPathComponent)
    do {
      /// 만약 이미지 파일이 Dir에 존재 한다면 Netwrok요청을 하지 않습니다.
//      let isExistImage = try isExistImageInDirectory(url: imagePathURL)
//      if isExistImage {
//        fetchFromLocal(url: url, target: target, completion: completion)
//      }
      
      /// 네트워크를 통해 Image를 Fetch합니다.
      fetchFromNetwork(url: url, target: target, completion: completion)
    } catch {
      completion(.failure(error))
      shared.targetViewAndFetchProperty.setObject(.init(fetchStatus: .init(.error(error)), fetchSubscription: nil), forKey: target)
    }
  }
  
  
  public static func cancelFetch(target: UIImageView) {
    shared.targetViewAndFetchProperty.object(forKey: target)?.cancelFetch()
    
  }
  
  public static func fetchPublisher(target: UIImageView) -> AnyPublisher<FetchManagerFetchStatus, Never>? {
    return shared.targetViewAndFetchProperty.object(forKey: target)?.fetchStatusPublisher()
  }
  
  public static func fetchStatus(target: UIImageView) -> FetchManagerFetchStatus? {
    return shared.targetViewAndFetchProperty.object(forKey: target)?.currentFetchStatus()
  }
  
}

private extension FileCacher {
  
  /// Local을 통해 Fetch 합니다
  private static func fetchFromLocal(url: URL, target: UIImageView, completion: @escaping (Result<Data, Error>) -> Void) {
    do {
      completion(.success(try Data(contentsOf: url)))
      shared.targetViewAndFetchProperty.setObject(.init(fetchStatus: .init(.finished), fetchSubscription: nil), forKey: target)
    }catch {
      completion(.failure(error))
      shared.targetViewAndFetchProperty.setObject(.init(fetchStatus: .init(.error(error)), fetchSubscription: nil), forKey: target)
    }
    
  }
  
  /// 네트워크를 통해서 Fetch합니다.
  private static func fetchFromNetwork(url: URL, target: UIImageView, completion: @escaping (Result<Data, Error>)-> Void){
    let fetchManager = ImageFileManagerProperty.fetchManager
    let description = fetchManager.dataTask(url: url, completion: completion)
    shared.targetViewAndFetchProperty.setObject(description, forKey: target)
  }
  
  /// 파일캐셔를 통해서 현재 이미지가 Dir에 저장되어있는지 확인합니다.
  private static func isExistImageInDirectory(url: URL) throws -> Bool{
    let fileManager = ImageFileManagerProperty.fileManger
    
    /// 만약 imageDirectory가 없다면 이미지 디렉토리를 생성합니다.
    if fileManager.fileExists(atPath: ImageFileManagerProperty.imageDirPath.path()) == false {
      try? fileManager.createDirectory(at: ImageFileManagerProperty.imageDirPath, withIntermediateDirectories: true)
    }
    return fileManager.fileExists(atPath: url.path())
  }

}



public extension UIImageView {
  func setImage(url: URL?, downSampleProperty property: DownSampleProperty? = nil) {
    FileCacher.loadImage(url: url, target: self) { [weak self] result in
      
      switch result {
      /// 성공했을 때 다운샘플링 프로퍼티에 따라서 이미지를 resizing 합니다.
      case let .success( data):
        self?.applyDownSampling(data: data, downSampleProperty: property)
        
      /// 에러가 발생했을 때 Error을 핸들링 하면 좋아 보임
      case let .failure(error):
        Logger().debug("<Error>\n\(error)")
        break
      }
    }
  }
  
  func cancelFetch() {
    FileCacher.cancelFetch(target: self)
  }
  
  func fetchPublisher() -> AnyPublisher<FetchManagerFetchStatus, Never>? {
    return FileCacher.fetchPublisher(target: self)
  }
  
  func fetchStatus() -> FetchManagerFetchStatus? {
    return FileCacher.fetchStatus(target: self)
  }
  
  
  func applyDownSampling(data: Data, downSampleProperty property: DownSampleProperty?) {
    let targetImage: UIImage? = property == nil ? UIImage(data: data) : data.downSample(downSampleProperty: property)
    
    DispatchQueue.main.async {
      self.image = targetImage
    }
  }
}
//
//  DownSampleProperty.swift
//  ImageManager
//
//  Created by MaraMincho on 2/12/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit

public struct DownSampleProperty {
  let size: CGSize
  let scale: Int
  init(size: CGSize, scale: Int = 1) {
    self.size = size
    self.scale = scale
  }
}

public extension Data {
  func downSample(downSampleProperty property: DownSampleProperty?) -> UIImage? {
    guard let property else { return nil }
    
    let data = self as CFData
    guard let imageSource = CGImageSourceCreateWithData(data, nil) else {
      return nil
    }
    
    let maxPixel = Swift.max(property.size.width, property.size.height)
    let downSampleOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: maxPixel
    ] as CFDictionary
    
    guard let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions) else {
      return nil
    }
    return UIImage(cgImage: cgImage)
  }
}
