//
//  WebServices.swift
//  GoodWeather
//
//  Created by MaraMincho on 2023/08/09.
//

import UIKit

struct Resource<T> {
    let url:URL
    let parse: (Data) -> T?
}

final class Webservice {
    
    func load<T>(resource: Resource<T>, completion:@escaping (T?)-> ()) {
        URLSession.shared.dataTask(with: resource.url) { data, resopnse, error in
            if let data = data  {
                DispatchQueue.main.sync {
                    let curStr = String(data: data, encoding: .utf8)
                    completion(resource.parse(data))
                }
                
            }else {
                completion(nil)
            }
            
        }.resume()
    }
}


