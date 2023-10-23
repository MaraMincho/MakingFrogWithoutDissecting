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
Flow layouts lay out their content using a fixed distance in one direction and a scrollable distance in the other. For example, in a vertically scrolling grid, the width of the grid content is constrained to the width of the corresponding collection view while the height of the content adjusts dynamically to match the number of sections and items in the grid. The layout scrolls vertically by default, but you can configure the scrolling direction using the scrollDirection property.

