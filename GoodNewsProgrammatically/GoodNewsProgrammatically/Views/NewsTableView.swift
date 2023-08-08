//
//  File.swift
//  GoodNewsProgrammatically
//
//  Created by MaraMincho on 2023/08/08.
//

import UIKit




class NewsTableView:UIView, UITableViewDelegate, UITableViewDataSource {
    
    var refresh: RefreshData!
    var articlesVM:ArticlesViewModel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        articlesVM = ArticlesViewModel(articles: [])
        setupUI()
        setUpBackgroundColor()
    }
    
    func setUpBackgroundColor() {
        self.backgroundColor = .white
    }
    
    
    private func setupUI() {
        
        
        
        //setuptitle
        self.addSubview(titleLabel)
        self.titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.titleLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true

        self.addSubview(recycleButton)
        self.recycleButton.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        self.recycleButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 30).isActive = true
        self.recycleButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.cellId)
        self.addSubview(newsTableView)
        self.newsTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        self.newsTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        self.newsTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.newsTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    
    var newsTableView:UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 250
        return tb
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "좋은 뉴스 한입?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var recycleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back Button", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(addTarget), for: .touchUpInside)
        return button
    }()
    
    @objc func addTarget() {
        refresh.loadNews()
    }
    
}


extension NewsTableView {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesVM.numOfArticles()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.cellId, for: indexPath) as? NewsCell
        else {
            fatalError("creating Cell Error")
        }
        cell.newsHeadLineLabel.text = articlesVM.articleIndex(at: indexPath.row).title
        cell.newsContent.text = articlesVM.articleIndex(at: indexPath.row).description
        return cell
    }
    

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

}
