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

class ViewController: UIViewController {
    
    var dataSource: [String] = []

    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 50 // cell사이의 간격 설정
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .cyan
        view.register(MyCell.self, forCellWithReuseIdentifier: MyCell.id)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private func setupDataSource() {
        for i in 0...10 {
            dataSource += ["\(i)"]
        }
    }
    private func configure() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
    
    private func setupDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupDataSource()
        configure()
        setupDelegate()
        
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
    }
    

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCell.id, for: indexPath)
        if let cell = cell as? MyCell {
            cell.bind(targetString: dataSource[indexPath.item])
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

          switch kind {
              
          case UICollectionView.elementKindSectionHeader:
              // 헤더 세팅
              guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HeaderReusableView else {
                  fatalError("Failed to load Header!")
              }
              return header
          case UICollectionView.elementKindSectionFooter:
              // 푸터 세팅
              guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as? FooterReusableView else {
                  fatalError("Failed to load Footer!")
              }
              return footer
          default: break
          }
          
          return UICollectionReusableView()
      }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - 셀의 hieght and width를 정하는 코드
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard collectionView.dequeueReusableCell(withReuseIdentifier: MyCell.id, for: indexPath) is MyCell else {
            return CGSize(width: 50, height: 50)
        }
        if indexPath.row % 2 == 0 {
            return CGSize(width: 320, height: collectionView.frame.height)
        }
        return CGSize(width: 160, height: 160)
    }
    
    // MARK: - cell의 헤더 크기를 정하는 코드
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 160, height: 160)
    }
    // MARK: - cell의 footer 크기를 정하는 코드
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: 160)
    }
    // MARK: - cell의 inset을 정하는 코드
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

class HeaderReusableView:UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .black
    }
}
class FooterReusableView:UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .gray
    }
}
