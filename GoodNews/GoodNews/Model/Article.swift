//
//  Article.swift
//  GoodNews
//
//  Created by MaraMincho on 2023/08/07.
//

import Foundation


struct ArticleList: Decodable {
    let articles: [Article]
}

struct Article: Decodable {
    let title: String
    let description: String
}
