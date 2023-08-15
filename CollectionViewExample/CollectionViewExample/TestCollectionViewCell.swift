//
//  TestCollectionViewCell.swift
//  CollectionViewExample
//
//  Created by MaraMincho on 2023/08/15.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TestCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setup() {
        self.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        self.addSubview(dateLabel)
        dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12).isActive = true
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        contentView.layer.cornerRadius = 3.0
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.black.cgColor
    }
    
    
}
