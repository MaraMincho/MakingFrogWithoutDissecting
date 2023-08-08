//
//  ArticleViewMOdel.swift
//  GoodNews
//
//  Created by MaraMincho on 2023/08/07.
//

import Foundation



struct ArticleListViewModel {
    let article: [Article]
    
    var numberOfSections: Int {
        return 1
    }
    func numberOfRowsInSecion(_ section: Int) -> Int {
        return self.article.count
    }
    func articleAtIndex(_ index: Int) -> ArticleViewModel {
        let article = self.article[index]
        return ArticleViewModel(article)
    }
}


struct ArticleViewModel {
    private let article: Article
}


extension ArticleViewModel {
    init( _ article: Article) {
        self.article = article
    }
}

extension ArticleViewModel {
    var title: String {
        return self.article.title
    }
    var description: String {
        return self.article.description
    }
}
