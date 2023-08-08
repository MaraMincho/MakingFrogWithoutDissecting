//
//  NewsCell.swift
//  GoodNewsProgrammatically
//
//  Created by MaraMincho on 2023/08/08.
//

import Foundation
import UIKit


class NewsCell: UITableViewCell {
    static let cellId = "News Cell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        setupUI()
    }
    
    
    private func setupUI() {
        self.addSubview(newsHeadLineLabel)
        newsHeadLineLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        newsHeadLineLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        newsHeadLineLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        newsHeadLineLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.addSubview(newsContent)
        newsContent.topAnchor.constraint(equalTo: newsHeadLineLabel.bottomAnchor, constant: 10).isActive = true
        newsContent.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        newsContent.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        newsContent.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        newsContent.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    
    var newsHeadLineLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var newsContent: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
}
