# 컬렉션뷰 레이아웃

##  [UICollectionViewLayout](https://developer.apple.com/documentation/uikit/uicollectionviewlayout)
- A layout object determines the placement of cells, supplementary views, and decoration views inside the collection view’s bounds and reports that information to the collection view. The collection view then applies the provided layout information to the corresponding views so that they can be presented onscreen.
- **레이아웃** 오브젝트는 CollecionView내부의 supplementary 뷰, decoration view들의 배치를 결정하며, 이것들을 컬렉션 뷰에게 전달한다. 컬렉션 뷰는 그 다음 제공된 **레이아웃**에 상응되는 뷰에게 적용하여 스크린에 보여지게 한다.


### You lay out three types of visual elements in a collection view:

- Cells are the main elements positioned by the layout. Each cell represents a single data item in the collection. You can make cells interactive so that a user can perform actions like selecting, dragging, and reordering the cells. A collection view can have a single group of cells, or you can divide those cells into multiple sections. The layout object arranges the cells in the collection view’s content area.
- 셀들은 레이아웃에 의해 포지션 되어야 하며, 셀들은 인터렉티브하게 동작할 수 있어야 한다. <br/><br/>

- Supplementary views present data but can’t be selected by the user. You use supplementary views to implement things like header and footer views for a given section or for the entire collection view. Supplementary views are optional and their use and placement is defined by the layout object.
- SupplementaryView는 데이터를 보여주는데 쓰여야 하며, 유저에 의해 선택되면 안된다. Supplementary뷰들은 섹션에서 헤더나 푸터로 이용되어야 한다. SupplementaryView는 optional이며 이용은 layout object에 의해 정의되어야 한다.
  <br/><br/>

- Decoration views are visual adornments, like badges, that can’t be selected and aren’t inherently tied to the data of the collection view. Decoration views are another type of supplementary view. Like supplementary views, they’re optional and their use and placement is defined by the layout object.
- DecorationView는 시각적 장식물(뱆지 같은) 그것들은 선택 하지 못하며, 컬렉션뷰 데이터에 본질적으로 묶여있지 않는다. Decoration 다른 타입은 supplementary 이다. supplementary 와 같이 optional이고 이용은 layout object에 의해 정의되어야 한다.
-   <br/><br/>


## [UICollectionViewFlowLayout](https://developer.apple.com/documentation/uikit/uicollectionviewflowlayout)

- A flow layout is a type of collection view layout. Items in the collection view flow from one row or column (depending on the scrolling direction) to the next, with each row containing as many cells as will fit. Cells can be the same sizes or different sizes.
<br/><br/>

- A flow layout works with the collection view’s delegate object to determine the size of items, headers, and footers in each section and grid. That delegate object must conform to the UICollectionViewDelegateFlowLayout protocol. Use of the delegate allows you to adjust layout information dynamically. For example, you use a delegate object to specify different sizes for items in the grid. If you don’t provide a delegate, the flow layout uses the default values you set in the properties of this class.
- flowLayout은 collecionview의 델리게이트 오브젝트와 자주 쓰이는데, 각 섹션의 아이템 및 헤더 푸터의 사이즈를 결정하기 위해서이다. 딜레게이트 객체는 반드시 `UICollectionViewDelegateFlowLayout`을 채택해야한다. 딜리게이트의 사용은 동적인 정보에 관한 레이아웃을 조정을 가능하게 한다. 예를 들어 딜레기이트의 사용은 그리드 내의 아이템들에게 다양한 사이즈를 만족하게 해준다. (여러 사이즈를 가능하게 해주는 것) 만약 delegate를 사용하지 않는다면, default value로 size를 만들게 해준다.

<br/><br/>
- Flow layouts lay out their content using a fixed distance in one direction and a scrollable distance in the other. For example, in a vertically scrolling grid, the width of the grid content is constrained to the width of the corresponding collection view while the height of the content adjusts dynamically to match the number of sections and items in the grid. The layout scrolls vertically by default, but you can configure the scrolling direction using the scrollDirection property.
- flowLayout은 한바향으로는 고정된 길이를 사용하며, 한방향으로는 스크롤 가능하게 한다. 예를들어 버티컬 스크롤 그리드에서, 너비는 상응하는 컬렉션뷰의 너비에 상응하고 높이는 섹션과 아이템의 갯수만큼 동적으로 조정된다. 레이아웃 스크롤은 버티컬이 기본이고, scrollDirection property를 사용하여 속성을 구성할 수 있다.

<br/><br/>
- Each section in a flow layout can have its own custom header and footer. To configure the header or footer for a view, configure the size of the header or footer to be non-zero. Implement the appropriate delegate methods or assign appropriate values to the headerReferenceSize and footerReferenceSize properties. If the header or footer size is 0, the corresponding view isn’t added to the collection view.
- flowLayout에서의 각각의 섹션에서 커스텀 헤더와 푸터를 가질 수 있다. 헤더와 푸터를 구성하기 위해, 사이즈를 0이 아닌 것으로 정한다. 적절한 딜리게이트 매서드나, 적절한 `aderReferenceSize` and `footerReferenceSize` 의 값을 할당하자. 헤더와 푸터 사이즈가 0이면 상응하는(헤더 푸터)뷰들은 collectionView에 추가되지 않는다. 



### 실제 컬렉션 뷰를 flowlayout으로 그려보기
- 컬렉션 뷰를 생성하는 코드이다.

```swift
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

```


- 컬렉션뷰를 lazyVar로 선언하고 내부에서 delegate와 datasource를 스스로 결정하게 해주었더니 알수없는 에러가 발생했다.

레퍼런스
- https://developer.apple.com/documentation/uikit/uicollectionviewflowlayout
- https://developer.apple.com/documentation/uikit/uicollectionviewlayout
- https://ios-development.tistory.com/632
- https://ios-daniel-yang.tistory.com/88
- 