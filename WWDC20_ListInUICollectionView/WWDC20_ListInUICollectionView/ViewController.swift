//
//  ViewController.swift
//  WWDC20_ListInUICollectionView
//
//  Created by MaraMincho on 1/23/24.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .gray
    
    setDataSource()
    setupViewHierarchyAndConstraints()
    let temp = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, itemIdentifier in
      
    }
  }
  
  private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewCompositionalLayout { index, environment in
      var configure = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
      configure.headerMode = .supplementary
      let section = NSCollectionLayoutSection.list(using: configure, layoutEnvironment: environment)
      return section
    }
    let cl = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cl.dataSource = self.dataSource
    cl.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.identifier)
    cl.register(<#T##viewClass: AnyClass?##AnyClass?#>, forSupplementaryViewOfKind: <#T##String#>, withReuseIdentifier: <#T##String#>)
    cl.backgroundColor = .gray
    
    cl.translatesAutoresizingMaskIntoConstraints = false
    return cl
  }()
  
  func setupViewHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    
    view.addSubview(collectionView)
    collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    collectionView.heightAnchor.constraint(equalToConstant: 350).isActive = true
  }
  func setDataSource() {
    dataSource = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
      
      return cell
    }
    
    var snapshot = dataSource.snapshot()
    snapshot.appendSections([0, 1, 2])
    snapshot.appendItems(["Issues", "PR", "Discussions", "Projects", "Repositories", "Organizations", "Stared"], toSection: 0)
    dataSource.apply(snapshot)
  }
}

final class CustomCell: UICollectionViewCell {
  static let identifier: String = String("CustomCell")
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
}
