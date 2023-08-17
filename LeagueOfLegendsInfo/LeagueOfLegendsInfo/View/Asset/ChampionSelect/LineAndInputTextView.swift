//
//  LineSelectView.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/17.
//

import UIKit

class LineAndInputTextView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(ChampionLineCollectionViewCell.self, forCellWithReuseIdentifier: ChampionLineCollectionViewCell.identifier)
        collectionView.contentMode = .scaleAspectFit
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(self.frame.width)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print(self.frame.width)
        setup()
    }
    
    func setup() {
        
        setupConstraints()
        setupLineCollectionViewDelegate()
        
    }
    
    
    private func setupLineCollectionViewDelegate() {
        lineCollectionView.delegate = self
        lineCollectionView.dataSource = self
    }
   
    
    func setupConstraints() {
        let width = self.frame.width
        
        self.addSubview(lineCollectionView)
        lineCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lineCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lineCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lineCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 5 - 4
        
        let size = CGSize(width: width, height: width)
        return size
    }

}
