//
//  NewsListTableViewController.swift
//  GoodNews
//
//  Created by MaraMincho on 2023/08/07.
//

import Foundation
import UIKit

class NewsListTableViewController: UITableViewController {
    
    private var articleListVM: ArticleListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setup()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    private func setup() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=kr&apiKey=94fcf972c2a64da7b2ee888a35af6718")!
        Swebservice().getArticles(url: url) { articles in
            guard let articles = articles else {return}
            self.articleListVM = ArticleListViewModel(article: articles)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.articleListVM == nil ? 0 : self.articleListVM.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListVM.numberOfRowsInSecion(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell ", for: indexPath) as? ArticleTableViewCell
        else {fatalError("ArticleTableViewCell not Found")}
        
        let articleVm = self.articleListVM.articleAtIndex(indexPath.row)
        cell.titleLabel.text = articleVm.title
        cell.descriptionLabel.text = articleVm.description
        return cell
        
    }
}
