//
//  ViewController.swift
//  GoodNewsProgrammatically
//
//  Created by MaraMincho on 2023/08/08.
//

import UIKit

class ViewController: UITableViewController, RefreshData {
    var newsTableView: NewsTableView!
    var newsServices: NewsServices!
    func setUpView() {
        self.view = NewsTableView()
    }
    
    override func loadView() {
        super.loadView()
        newsTableView = NewsTableView(frame: self.view.frame)
        newsTableView.refresh = self
        self.view = newsTableView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newsServices = NewsServices()
        
        loadNews()
        // Do any additional setup after loading the view.
    }
    
    func loadNews() {
        self.newsTableView.articlesVM = ArticlesViewModel(articles: [])
        DispatchQueue.main.async {
            self.newsTableView.newsTableView.reloadData()
        }
        newsServices.getNews(completion: { articles, error in
            guard error == nil else {
                return print(error!.localizedDescription)
            }
            guard let articles = articles else {return}
            self.newsTableView.articlesVM = ArticlesViewModel(articles: articles)
            DispatchQueue.main.async {
                self.newsTableView.newsTableView.reloadData()
            }
        })
    }
}

protocol RefreshData {
    func loadNews()
}

