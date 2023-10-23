//
//  TestCollectionViewCell.swift
//  CollectionViewExample
//
//  Created by MaraMincho on 2023/08/15.
//
import UIKit

class MyCell: UICollectionViewCell {

    static var id: String = "MyCell"

    var model: String?

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func addSubviews() {
        addSubview(titleLabel)
    }

    private func configure() {
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        backgroundColor = .placeholderText
    }

    func bind(targetString: String) {
        titleLabel.text = targetString
    }

}
