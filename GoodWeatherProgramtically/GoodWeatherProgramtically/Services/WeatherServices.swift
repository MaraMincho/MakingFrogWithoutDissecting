//
//  WeatherServices.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct Resource<T> {
    var httpRequestType: HTTPMethod
    var data: Data?
    var url: URL
}

class WeatherServices {
    func load<T:Codable>(resource: Resource<T>, completion: @escaping (Result<T, Error>) -> Void) {
        
        let urlRequest = getCurrentURLRequset(resource: resource)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                return completion(.failure(error!))
            }
            guard let curStruct = try? JsonHelper.jsonDecoer.decode(T.self, from: data!) else{
                return completion(.failure(UserError.jsonDecodeError))
            }
            
            return completion(.success(curStruct))
        }.resume()
    }
    
    func getCurrentURLRequset<T>(resource: Resource<T>) -> URLRequest {
        var URLRequst = URLRequest(url: resource.url)
        URLRequst.httpBody = resource.data
        URLRequst.httpMethod = resource.httpRequestType.rawValue
        URLRequst.addValue("Content-Type", forHTTPHeaderField: "application/json")
        return URLRequst
    }
    
}

enum JsonHelper {
    static let jsonDecoer = JSONDecoder()
    static let jsonEncoder: JSONEncoder = {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.prettyPrinted]
        return jsonEncoder
    }()
}


enum UserError: Error {
    case jsonDecodeError
}
