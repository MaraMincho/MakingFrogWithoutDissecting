//
//  ChampionsPortrait.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/17.
//

import UIKit

class ChampionsPortraitCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var viewModel: ChampionsPortraitDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.champions.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = championsPortraitCollections.dequeueReusableCell(withReuseIdentifier: ChampionsPortraitCollectionViewCell.identifier, for: indexPath) as? ChampionsPortraitCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.championImageView.image = UIImage(systemName: "person")
        cell.championNameLabel.text = viewModel?.champions[indexPath.row].korName
        return cell
    }
    
    
    
    
    private let championsPortraitCollections: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(ChampionsPortraitCollectionViewCell.self, forCellWithReuseIdentifier: ChampionsPortraitCollectionViewCell.identifier)
        collectionView.contentMode = .scaleAspectFit
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public func reloadCahmpionsPortraitCollectionView() {
        self.championsPortraitCollections.reloadData()
        
    }
    
    
    func setup() {
        setupConstraints()
        setupCollectionViewDelegate()
    }
    
    private func setupCollectionViewDelegate() {
        championsPortraitCollections.dataSource = self
        championsPortraitCollections.delegate = self
    }
    
    func setupConstraints() {
        self.addSubview(championsPortraitCollections)
        championsPortraitCollections.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        championsPortraitCollections.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        championsPortraitCollections.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        championsPortraitCollections.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    
}


// MARK: - 셀의 옆과 위아래 간격 설정
extension ChampionsPortraitCollectionView {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.width
        let cellwidth = (width / 5) - 5
        let height = cellwidth + 15
        
        let size = CGSize(width: cellwidth, height: height)
        return size
    }
}

