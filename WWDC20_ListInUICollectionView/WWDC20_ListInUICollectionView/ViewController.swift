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
  }
  
  private var dataSource: UICollectionViewDiffableDataSource<CustomCollectionViewSection, Int>!
  
  lazy var collectionView: UICollectionView = {
    let cl = UICollectionView(frame: .zero, collectionViewLayout: makeCompositionalLayout())
    cl.dataSource = dataSource
    cl.backgroundColor = .gray
    
    cl.translatesAutoresizingMaskIntoConstraints = false
    return cl
  }()
  
  func setupViewHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    
    view.addSubview(collectionView)
    collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
  }
  let cellRegistration = UICollectionView.CellRegistration<CustomCell, Int> { cell, indexPath, itemIdentifier in
    cell.configure(text: "\(itemIdentifier) 입니다")
  }
  
  let adCellRegistration: UICollectionView.CellRegistration<SmallADCell, Int> = .init { cell, indexPath, itemIdentifier in
    cell.configure(text: "\(itemIdentifier) 광고예용 ^_^")
  }
  
  let listCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Int> = .init { cell, indexPath, itemIdentifier in
    var configure = cell.defaultContentConfiguration()
//    configure.text = "\(itemIdentifier), Text"
//    cell.contentConfiguration = configure
//    cell.accessories = [
//      .disclosureIndicator(displayed: .always),
//      .checkmark(),
//      .delete(displayed: .always),
//      .reorder(displayed: .always),
//    ]
  }
  
  
  func setDataSource() {
    dataSource = .init(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
      
      guard let section = CustomCollectionViewSection(rawValue: indexPath.section),
            let self
      else {
        return UICollectionViewCell()
      }
      
      switch section {
      case .top:
        return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
      case .advertise:
        return collectionView.dequeueConfiguredReusableCell(using: self.adCellRegistration, for: indexPath, item: itemIdentifier)
      case .list :
        return collectionView.dequeueConfiguredReusableCell(using: self.listCellRegistration, for: indexPath, item: itemIdentifier)
      default:
        return UICollectionViewCell()
      }
    }
    
    let header: UICollectionView.SupplementaryRegistration<CustomHeader> = .init(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
      supplementaryView.backgroundColor = [.red, .blue , .black][Int.random(in: 0...2)]
    }
    dataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
      print(elementKind)
      if elementKind == UICollectionView.elementKindSectionHeader {
        print(indexPath)
        let cell = collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
        return cell
      }
      
      return nil
    }
    
    
    var snapShot = dataSource.snapshot()
    snapShot.appendSections([.top, .advertise, .list])
    //snapShot.appendItems([1, 2, 3, 4, 5], toSection: .top)
    //snapShot.appendItems((6...20).map{$0}, toSection: .advertise)
    snapShot.appendItems((21...24).map{$0}, toSection: .list)
    dataSource.apply(snapShot)
  }
  
  func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
    
    return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
      guard
        let sectionType = CustomCollectionViewSection(rawValue: sectionIndex),
        let section = self?.make(customCollectionViewSection: sectionType, env: environment)
      else {
        return nil
      }
      
      return section
    }
  }
  
  func make(customCollectionViewSection section: CustomCollectionViewSection, env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
    switch section {
    case .top:
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = .init(top: 5, leading: 5, bottom: 10, trailing: 5)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .estimated(150))
      let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
      
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .groupPaging
      let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(50.0))
      let header = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: footerHeaderSize,
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top)
      
      section.boundarySupplementaryItems = [ header ]
      
      return section
    case .advertise :
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = .init(top: 5, leading: 5, bottom: 10, trailing: 5)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .estimated(80))
      let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
      
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous
      
      return section
    case .list :
      var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
      configuration.headerMode = .firstItemInSection
      let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: env)
      
      return section
    default :
      return nil
    }
  }
}

final class CustomCell: UICollectionViewCell {
  static let identifier: String = String("CustomCell")
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    addSubview(titleLabel)
    titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    
    layer.cornerRadius = 9
    layer.borderWidth = 1.5
    layer.masksToBounds = true
    layer.cornerCurve = .continuous
    layer.borderColor = UIColor.gray.cgColor
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "초기 값"
    label.textColor = .black
    
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  func configure(text: String) {
    titleLabel.text = text
  }
}

final class SmallADCell: UICollectionViewCell {
  static let identifier: String = String("CustomCell")
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    addSubview(titleLabel)
    titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    
    layer.cornerRadius = 9
    layer.borderWidth = 1.5
    layer.masksToBounds = true
    layer.cornerCurve = .continuous
    layer.borderColor = UIColor.gray.cgColor
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "초기 값"
    label.textColor = .black
    
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  func configure(text: String) {
    titleLabel.text = text
  }
}


enum CustomCollectionViewSection: Int {
  case top
  case advertise
  case list
  case board
  case bigAdvertise
}


final class CustomCollectionViewListCell: UICollectionViewListCell {
  
}

final class CustomHeader: UICollectionReusableView {
  
}
