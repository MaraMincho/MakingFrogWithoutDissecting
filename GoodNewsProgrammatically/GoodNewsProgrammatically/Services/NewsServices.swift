//
//  NewsServices.swift
//  GoodNewsProgrammatically
//
//  Created by MaraMincho on 2023/08/08.
//

import Foundation

class NewsServices {

    func getNews(completion: @escaping ([Article]?) -> ()) throws {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=kr&apiKey=94fcf972c2a64da7b2ee888a35af6718")
        else {
            throw ServicesError.WrongURL
        }
        var urlRquest = URLRequest(url: url)
        urlRquest.timeoutInterval = .greatestFiniteMagnitude
        urlRquest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                fatalError(ServicesError.WrongConnection.localizedDescription)
            }
            
            guard let article = try? JSONDecoder().decode(ArticleList.self, from: data) else {
                completion(nil)
                fatalError(ServicesError.cantDecodeJson.localizedDescription)
            }
            return completion(article.articles)
        }.resume()
        
    }
}


enum JsonDecoder {
    static var jsonDecoder:JSONDecoder = {
        let js = JSONDecoder()
        return js
    }()
}


enum ServicesError: Error, LocalizedError {
    case WrongURL
    case cantDecodeJson
    case WrongConnection
    
    public var errorDescription: String? {
        switch self {
        case .WrongURL :
            return "잘못된 URL접근입니다."
        case .WrongConnection :
            return "서버에 접근할 수 없습니다."
        case .cantDecodeJson :
            return "json을 파싱할 수 없습니다."
        }
    }
}

