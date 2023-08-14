//
//  Services.swift
//  NetwrokingExample
//
//  Created by MaraMincho on 2023/08/14.
//

import Foundation
import Combine

enum networkError:Error {
    case responseError
    case urlError
}

class NetwrokService {
    var beg = Set<AnyCancellable>()
    
    func cmpletionWay<T: Codable>(resource: Resource<T>, completion: @escaping (Result<T, Error>) -> ()){
        guard let urlRequest = createURLRequstByResource(resource: resource) else {
            return completion(.failure(networkError.responseError))
        }
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse else {return}
            
            guard 200...299 ~= response.statusCode else {return completion(.failure(networkError.responseError))}
            
            guard error == nil else {return completion(.failure(networkError.responseError)) }
            
            guard let data = data,
                  let genericData = try? JSONDecoder().decode(T.self, from: data)
            else {return completion(.failure(networkError.responseError)) }
            
            return completion(.success(genericData))
        }.resume()
    }
    
    func publishWay<T: Codable>(resource: Resource<T>) async throws -> T{
        guard let urlRequest = createURLRequstByResource(resource: resource)
        else {
            throw networkError.urlError
        }
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw networkError.responseError
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw networkError.responseError
        }
        guard let genericData = try? JSONDecoder().decode(T.self, from: data) else{
            throw networkError.responseError
        }
        return genericData
    }
    
    func createURLRequstByResource<T>(resource: Resource<T>) -> URLRequest?{
        var urlSession = URLRequest(url: resource.url, timeoutInterval: .greatestFiniteMagnitude)
        urlSession.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlSession.httpBody = resource.body
        urlSession.httpMethod = resource.httpMethod.rawValue
        
        return urlSession
    }
}

struct Resource<T:Codable> {
    let url: URL
    let httpMethod:HTTPMethod
    var body: Data? = nil
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
