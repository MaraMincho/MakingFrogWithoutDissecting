//
//  ViewController.swift
//  CollectionViewExample
//
//  Created by MaraMincho on 2023/08/15.
//

import UIKit

struct Diary {
    let name: String
    let date: String
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let testsDiary = [Diary(name: "1123", date: "1233"), Diary(name: "gkdl", date: "asdf")]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testsDiary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCollectionViewCell.identifier, for: indexPath) as? TestCollectionViewCell
        else {return UICollectionViewCell()}
        
        cell.titleLabel.text = testsDiary[indexPath.row].name
        cell.dateLabel.text = testsDiary[indexPath.row].date
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(collectionView)
        let safeArea = self.view.safeAreaLayoutGuide
        
        collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 20, height: 200)
        
        let collectioView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectioView.backgroundColor = .white
        collectioView.register(TestCollectionViewCell.self, forCellWithReuseIdentifier: TestCollectionViewCell.identifier)
        collectioView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectioView.translatesAutoresizingMaskIntoConstraints = false
        return collectioView
    }()
}

