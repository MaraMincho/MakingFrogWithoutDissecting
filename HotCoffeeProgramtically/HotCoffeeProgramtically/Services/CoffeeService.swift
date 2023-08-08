//
//  CoffeeService.swift
//  HotCoffeeProgramtically
//
//  Created by MaraMincho on 2023/08/08.
//

import Foundation




class CoffeeService {
    func load<T>(resource: Resource<T>, completeion: @escaping (Result<T, Error>) -> Void) {
        let request = getHTTPREqueset(resource: resource)
        
        print(T.self)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else{
                return completeion(.failure(ServiceError.serviceError))
            }
            
            guard let data = data else {
                return completeion(.failure(ServiceError.noData))
            }
            
            guard let result = try? JsonHelper.jsonDecoder.decode(T.self, from: data) else {
                print(String(data: data, encoding: .utf8)!)
                return completeion(.failure(ServiceError.jsonDecodeError))
            }
            return completeion(.success(result))
        }.resume()
    }
    
    
    private func getHTTPREqueset<T>(resource: Resource<T>) -> URLRequest {
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = resource.data
        return request
    }
}
