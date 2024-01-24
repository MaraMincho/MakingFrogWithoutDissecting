
# UICollectionView Compostional Layout 으로 TableView만들기 (WWDC20 List in UIColelctionView )


## 글 작성 개요
CompositionalLyaout이 UITableView를 완전하게 대체할 수 있지 않을까라는 조그마한 의문에서 시작하게 되었음. 그래서 관련 세션이 있나 찾아 보았는데 [WWDC20 List in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10026/)를 보게 되었고 이에 대한 내용을 정리하기로 했음

## Modern Collection Views

UICollectionView를 구성하는 API는 데이터, 레이아웃, 프레젠테이션의 세 가지 카테고리로 구분할 수 있습니다. UICollectionView의 새로운 개념 중 하나는 콘텐츠가 렌더링되는 '위치'인 레이아웃과 '무엇'인 데이터를 분리하는 것이었습니다. 이러한 구분은 UICollectionView를 유연하게 만드는 핵심 요소입니다.

FLowLayout은 CollectionViewDataSource를 제공하는 Delegate를 통해서 관리를 할 수 있습니다. CompostionalLyaout은 DiffableDataSource를 통해서 Delegate보다 쉽게 CollectionView의 DataSource를 건들 수 있습니다.

|basic|iOS13 이전 `FlowLayout`|iOS13 이후 `CompositionalLyaout`|
|:-:|:-:|:-:|
|<img src="https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/0597bb78-7f83-40a4-bedb-6763f3903c00" width=600>|<img src="https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/d0cdd98a-6b4c-48f7-afde-969b3c2a0f57" width = 600>|<img src="https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/ddad0c1c-3178-477f-bf0e-fa55c9f75afc" width=600>|
        

<br/><br/>

## CellRegistration
보통 CollectionView를 사용하기 위해 Cell를 Registration하고는 합니다. 이 Cell Registration에서는 몇가지 불편한 점이 있습니다.
- unique Identifer를 필수적으로 만들어야 합니다.
- 또한 Cell을 dequeue할 떄 타입 캐스팅을 해야 합니다. ex) `guard let ... = ... as? CustomCell else { }`
  
<br/>

이를 간단하게 하는 방법으로 [UICollectionView.CellRegistration](https://developer.apple.com/documentation/uikit/uicollectionview/cellregistration)을 활용합니다. 이를 코드를 통해서 설명하겠습니다.

### Register 방식
아래는 identifer를 통해서 Cell을 등록하는 과정입니다.
```swift
var dataSrouce: UICollectionViewDiffableDataSource?

func setupDataSource() {
    collectionView.register(anyClass, identifier: String) 
    dataSource = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else {
        return ...
    }
    cell.configure(...)
    return cell
    }
}
```

### UICollectionView.CellRegistration 소개
다음은 CellRegisteration 방식입니다.

```swift
let cellRegistration = UICollectionView.CellRegistration<CustomCell, Int> { cell, indexPath, itemIdentifier in
    //TODO: Some Configureation must be write for CollectionViewCell
  }
func setupDataSource() {
    collectionView.register(anyClass, identifier: String) 
    dataSource = .init(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
        guard let self else { return UICollectionViewCell() }
        let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
        return cell
    }
}
```

<br/>

### UICollectionView.CellRegistration 이점
이러한 방식은 CompostionalLayout에 Multiple Section에서 매우 빛을 바랍니다. 다음 화면을 통해서 설명드리겠습니다.

|||
|-|-|
|<img src= "https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/51a0d577-1835-4a6e-888c-774c1145af75" width = 300>|<img src= "https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/2ea63ffc-7d2d-431d-b192-182c40006780" width = 400>

위와 같이 Multiple Section일 경우에는 각기 다른 Section에 View를 Configure하는 다른 방법을 해야 합니다. 물론 이전에 등록했던 것 처럼 할 수 있지만, 애플에서 소개한 `CollectionView.registration을` 통해서 하면 간단하게 구현 할 수 있습니다.


## TableView Section 만들기
`UICollectionViewCompositionalLayoutSectionProvider`을 활용하여 `CompostionalLayout`을 만들면 됩니다. 
```swift
let layout = UICollectionViewCompositionalLayout() {
    [weak self] sectionIndex, layoutEnvironment in
    guard let self = self else { return nil }

    // @todo: add custom layout sections for various sections
  
    let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
    return section
}
``` 
`UICollectionLayoutListConfiguration(appearance:)`의 appearance의 타입은 자주 사용하는 UITableView와 매우 유사합니다. <br/>
공식 문서에는 다음과 같이 기재되어 있습니다.
- case plain
  - The plain list appearance.
- case grouped
  - The grouped list appearance.
- case insetGrouped
    - The inset grouped list appearance.
- case sidebar
    - The sidebar list appearance.
- case sidebarPlain
    - The plain sidebar list appearance.

실제 코드로 보면 다음과 같습니다.

|palin|grouped|insetGrouped|sidebar|sidebarPlain|
|:-:|:-:|:-:|:-:|:-:|
|![plain](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/117c8c96-2e9d-41c6-8dde-bcb865b2fcc1)|![group](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/693d3f5c-64ee-446e-a7f4-71fb03bf95dd) | ![insetGrouped](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/e21b4c61-5d44-4b89-80a7-6d8bc3de1232) | ![sidebar](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/1b552407-1b1e-4273-9429-b8ec5bb9a226) | ![sidebarPlain](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/c0a38585-1a0f-4faf-ad8b-ec994430cbd0)|


## DiffableDataSource에 Header와 Footer 추가하기

### 정통 방식
WWDC에서 diffableDataSource를 통해서 Header와 Footer를 추가하는 방법을 다음과 같이 설명했습니다. layout을 통해서 생성엉된 supplementaryView를 다음과 같이 dequeue해서 보여줍니다. 
```swift
dataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) in
    if elementKind == UICollectionView.elementKindSectionHeader {
        return collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
    }
    else {
        return nil
    }
}
```

<br/>


## 헤더 추가하기 
### Supplementary
`UICollectionLayoutListConfiguration`의 HeaderMode를 적절하게 조정하여 헤더를추가할 수 있습니다.

```swift
var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
configuration.headerMode = .supplementary
let layout = UICollectionViewCompositionalLayout.list(using: configuration)

dataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) in
    if elementKind == UICollectionView.elementKindSectionHeader {
        return collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
    }
    else {
        return nil
    }
}
```

<br/>

### UICollectionLayoutListConfiguration.HeaderMode.firstItemInSection
`HeaderMode.firstItemInSection`을 통해서 첫 번째 아이템을 Header로 만들 수 있습니다. 
```swift
var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
configuration.headerMode = .firstItemInSection
let layout = UICollectionViewCompositionalLayout.list(using: configuration)
```


### 레퍼런스

[cellregistration](https://developer.apple.com/documentation/uikit/uicollectionview/cellregistration)

[UICollectionLayoutSectionOrthogonalScrollingBehavior](https://developer.apple.com/documentation/uikit/uicollectionlayoutsectionorthogonalscrollingbehavior)

[UicolleCtionViewCompositionalLayout](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout)

[wwdc 20 List in UICollectionView ](https://developer.apple.com/videos/play/wwdc2020/10097)