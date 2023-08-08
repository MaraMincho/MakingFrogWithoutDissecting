//
//  NewsViewModel.swift
//  GoodNewsProgrammatically
//
//  Created by MaraMincho on 2023/08/08.
//

import Foundation


struct ArticlesViewModel {
    var articles: [Article]
    func numOfArticles() -> Int {
        return self.articles.count
    }
    func articleIndex(at: Int) -> ArticleViewModel {
        let curArticle = articles[at]
        return ArticleViewModel(curArticle)
    }
}

struct ArticleViewModel {
    private let article: Article
    init(_ article: Article) {
        self.article = article
    }
    
    public var title: String {
        get {
            return article.title ?? ""
        }
    }
    
    public var description: String {
        get {
            return article.description ?? ""
        }
    }
}

