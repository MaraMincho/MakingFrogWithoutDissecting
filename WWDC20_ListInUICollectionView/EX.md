# Nested Section CollectionView 만들기

### 목표 화면
<img src="https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/2498ed3e-1209-48a1-a064-4b4dacd09f95" width = 450>


<br/><br/>

### 1. diffableDataSource 와 섹션 layout 만들기

섹션에 따른 각기 다른 레이아웃 구상 
```swift
private var dataSource: UICollectionViewDiffableDataSource<CustomCollectionViewSection, 
Int>!

func make(customCollectionViewSection section: CustomCollectionViewSection, env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
    switch section {

    // Top Section
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
    
    // List Section
    case .list :
      var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
      configuration.headerMode = .firstItemInSection
      let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: env)
      
      return section
    default :
      return nil
    }
  }
```

<br/><br/>

### Use DataSource and Cell Registration 
데이터소스와 Cell Registration 을 활용합니다.
```swift
    
 let cellRegistration = UICollectionView.CellRegistration<CustomCell, Int> { cell, indexPath, itemIdentifier in
    cell.configure(text: "\(itemIdentifier) 입니다")
  }
  
  let adCellRegistration: UICollectionView.CellRegistration<SmallADCell, Int> = .init { cell, indexPath, itemIdentifier in
    cell.configure(text: "\(itemIdentifier) 광고예용 ^_^")
  }
  
  let listCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Int> = .init { cell, indexPath, itemIdentifier in
  }
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
```

### Apply snapthot
스냅샷 적용
```swift
var snapShot = dataSource.snapshot()
snapShot.appendSections([.top, .advertise, .list])
snapShot.appendItems([1, 2, 3, 4, 5], toSection: .top)
snapShot.appendItems((6...20).map{$0}, toSection: .advertise)
snapShot.appendItems((21...24).map{$0}, toSection: .list)
dataSource.apply(snapShot)

```

### 공부했던 개념
- CompostionalLayout의 `Item`, `Group`, `Section` 의 이해
- `NSCollectionLayoutSection.orthogonalScrollingBehavior` 을 통한 `Section Scroll`
