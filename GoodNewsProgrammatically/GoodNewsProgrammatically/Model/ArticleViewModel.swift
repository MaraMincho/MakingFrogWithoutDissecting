//
//  NewsModel.swift
//  GoodNewsProgrammatically
//
//  Created by MaraMincho on 2023/08/08.
//

import Foundation

struct ArticleList: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String?
    let description: String?
}
