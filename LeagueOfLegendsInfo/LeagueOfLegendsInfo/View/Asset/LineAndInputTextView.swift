//
//  LineSelectView.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/17.
//

import UIKit

class LineAndInputTextView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = lineCollectionView.dequeueReusableCell(withReuseIdentifier: ChampionLineCollectionViewCell.identifier, for: indexPath) as? ChampionLineCollectionViewCell
        else {return UICollectionViewCell()}
        
        cell.lineImage.image = UIImage(systemName: "bolt.heart.fill")
        return cell
    }
    
    
    
    private let lineCollectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.register(ChampionLineCollectionViewCell.self, forCellWithReuseIdentifier: ChampionLineCollectionViewCell.identifier)
        
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let championNameTextField: UITextField = {
        let tf = UITextField()
        tf.layer.borderWidth = 5
        tf.layer.borderColor = UIColor.black.cgColor
        tf.borderStyle = .roundedRect
        tf.placeholder = "이름"
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        setupConstraints()
        setupLineCollectionViewDelegate()
        setupChampionNameTextFielDelegate()
    }
    
    
    private func setupLineCollectionViewDelegate() {
        lineCollectionView.delegate = self
        lineCollectionView.dataSource = self
    }
    private func setupChampionNameTextFielDelegate() {
        championNameTextField.delegate = self
    }
    
    
    func setupConstraints() {
        let width = self.frame.width
        
        self.addSubview(lineCollectionView)
        lineCollectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        lineCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lineCollectionView.widthAnchor.constraint(equalToConstant: (width / 9) * 5).isActive = true
        
        self.addSubview(championNameTextField)
        championNameTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        championNameTextField.leadingAnchor.constraint(equalTo: lineCollectionView.trailingAnchor, constant: 20).isActive = true
        championNameTextField.widthAnchor.constraint(equalToConstant: (width / 9) * 3).isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 3
        
        let size = CGSize(width: width, height: width)
        return size
    }

}
