//
//  CoffeeService.swift
//  HotCoffeeProgramtically
//
//  Created by MaraMincho on 2023/08/08.
//

import Foundation


enum httpMethod: String {
    case post = "POST"
    case get = "GET"
}

struct Resource {
    var url: URL
    let data: Data? = nil
    var httpMethod: httpMethod = .get
}


enum ServiceError: Error, LocalizedError {
    case serviceError
    case jsonDecodeError
    
    
}


class CoffeeService {
    func load<T>(resource: Resource, completetion: @escaping (Result<T, Error>) -> Void) {
        let request = getHTTPREqueset(resource: resource)
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else{
                return completetion(.failure(<#T##Error#>))
            }
        }
    }
    
    private func getHTTPREqueset(resource: Resource) -> URLRequest {
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = resource.data
        return request
    }
}
