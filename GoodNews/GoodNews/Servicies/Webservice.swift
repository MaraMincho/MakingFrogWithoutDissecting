//
//  Webservice.swift
//  GoodNews
//
//  Created by MaraMincho on 2023/08/07.
//

import Foundation


class Swebservice {
    func getArticles(url: URL, completion: @escaping ([Article]?) -> ()) {
        URLSession.shared.dataTask(with: url) {data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("emptyData")
                return
            }
            
            let articleList = try? JSONDecoder().decode(ArticleList.self, from: data)
            if let articleList = articleList {
                completion(articleList.articles)
                
            }
        }.resume()
    }
}


