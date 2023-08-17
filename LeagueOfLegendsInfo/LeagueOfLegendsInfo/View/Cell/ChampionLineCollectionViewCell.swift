//
//  ChampionLineCollectionViewCell.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/17.
//

import UIKit


class ChampionLineCollectionViewCell: UICollectionViewCell {
    static let identifier = "ChampionLineCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    public let lineImage: UIImageView = {
        let image = UIImage(systemName: "bolt.heart.fill")
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setup() {
        setupConstraints()
    }
    func setupConstraints() {
        
        self.addSubview(lineImage)
        lineImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        lineImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        lineImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3).isActive = true
        lineImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3).isActive = true
    }
}
