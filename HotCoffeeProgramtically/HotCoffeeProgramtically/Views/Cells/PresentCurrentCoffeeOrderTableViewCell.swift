//
//  PresentCurrentCoffeeOrderTableViewCell.swift
//  HotCoffeeProgramtically
//
//  Created by MaraMincho on 2023/08/08.
//
import UIKit


class PresentCurrentCoffeeOrderTableViewCell: UITableViewCell{
    static var identifier = "PresentCurrentCoffeeOrderTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}


extension PresentCurrentCoffeeOrderTableViewCell {
    func setup() {
        setupConstarints()
    }
    
    func setupConstarints() {
        self.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        self.addSubview(descriptionLabel)
        descriptionLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20).isActive = true
    }
}
