//
//  ChampionsPortraitCollectionViewCell.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/17.
//

import UIKit

class ChampionsPortraitCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ChampionsPortraitCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    let championNameLabel: UILabel = {
        let label = UILabel()
        label.font = ConstOfFontUnit.descriptionFont
        label.textColor = .systemGray
        label.textAlignment = .center
        label.contentMode = .scaleAspectFit
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let championImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setup() {
        setupConstraints()
    }
    
    func setupConstraints() {
        self.addSubview(championImageView)
        championImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        championImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        championImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.addSubview(championNameLabel)
        championNameLabel.topAnchor.constraint(equalTo: championImageView.bottomAnchor, constant: 5).isActive = true
        championNameLabel.leadingAnchor.constraint(equalTo: championImageView.leadingAnchor).isActive = true
        championNameLabel.trailingAnchor.constraint(equalTo: championImageView.trailingAnchor).isActive = true
    }

    
}

