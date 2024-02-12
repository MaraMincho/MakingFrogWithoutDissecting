//
//  ViewController.swift
//  TIL_SafeResultHandler
//
//  Created by MaraMincho on 2/12/24.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

}

enum NetworkError: LocalizedError {
  case NoDataError
}
final class Network {
  func fetchData(url: URL, _ completion: @escaping (Result<Data, Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { data, _, error in
      guard error == nil else {
        completion(.failure(error!))
        return
      }
      
      guard let data else {
        completion(.failure(NetworkError.NoDataError))
        return
      }
      
      completion(.success(data))
    }
    .resume()
  }
  
  func fetchData2(url: URL, _ completion: @escaping (Result<Data, Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { data, _, error in
      
      let result: Result<Data, Error>
      defer {
        completion(result)
      }
      guard error == nil else {
        result = .failure(error!)
        return
      }
      
      guard let data else {
        result = .failure(NetworkError.NoDataError)
        return
      }
      
      result = .success(data)
    }
    .resume()
  }
  
}

