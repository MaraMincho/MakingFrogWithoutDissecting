# iOS 트러블 슈팅 UIStackView만들기


### UIStackView에 관한 트러블 슈팅 입니다.

# 글 작성 개요

최근 UIStackView를 활용하여 UI를 만들 일이 있었습니다. 다음과 같은 Layout을 만들기 위해 StackView를 활용하여 작성을 했는데요, StackView의 Size가 어떤 방식으로 바뀌는지 헷갈려서 글을 작성합니다.

<img src = "https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/b35f6eff-6f1a-427d-acae-4f9062ba4688" width = 300>

<br/><br/>

# UIStackView의 컴포넌트 크기

## 내부 컴포넌트의 크기가 0 일때

UIStackView는 처음 컴보넌트와 맨 나중의 컴포넌트를 통해서 그 IntrinsicSize가 정해집니다. 즉 append된 Component가 고유의 사이즈를 통해서 StackView의 크기가 의존적이라는 말 입니다. 다음 사진을 통해서 설명 하겠습니다. 

만약 높이를 지정하지 않으면, 내부 `Content`의 높이를 지정하지 않으면, `UIStackView`의 높이 또한 0이 됩니다. 따라서 아래의 코드는 아무것도 그려낼 수 없습니다. 

```swift
let aContentView: UIView = {
  let view = UIView()
  view.backgroundColor = .red
  
  view.translatesAutoresizingMaskIntoConstraints = false
  return view
}()

let bContentView: UIView = {
  let view = UIView()
  view.backgroundColor = .blue
  
  view.translatesAutoresizingMaskIntoConstraints = false
  return view
}()

private lazy var testStackView: UIStackView = {
  let st = UIStackView(arrangedSubviews: [aContentView, bContentView])
  st.backgroundColor = .gray
  
  st.translatesAutoresizingMaskIntoConstraints = false
  return st
}()

private func setupViewHierarchyAndConstraints() {
  let safeArea = view.safeAreaLayoutGuide
  view.addSubview(testStackView)
  testStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30).isActive = true
  testStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
  testStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
	}
```

<img src = "https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/3bbd100f-9dfb-4b3c-83ae-6e7f7a004654" width = 250>


<br/><br/>

## 내부 컴포넌트의 크기에 따른 UIStackView

- `Height`을 지정했지만, width를 지정하지 않았다면, Proportion이 낮은 Component에 의해서 Width가 채워집니다. 사실 aContentView가 StackView를 완전히 채운것 같아서 bContentView가 없어 보인다고 생각하실 수 있습니다. 하지만 StackView안에 있습니다.
    - `bContentView.heightAnchor.constraint(equalToConstant: 150).isActive = true` 추가
    
    ![Untitled 2](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/068b1754-9818-4e44-be65-116d25501997)
    
<br/><br/>

- `height`과 `width`를 둘 다 지정했을 때 어떻게 진행될 것 같나요? 예상하셨던 결과 처럼 Proportion에 따라 빈 공간을 채울 것 입니다.
    
    `bContentView.widthAnchor.constraint(equalToConstant: 30).isActive = true`
    
    ![Untitled 3](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/621a3d9e-76a6-4eb2-8e58-13ec67829a64)
    

<br/><br/>

- 그러면 Proportion이 낮은 `aContentView`(빨강색)에 높이와 크기를 지정하면 어떻게 될까요? (a): StackView의 distribution이 fill이니까, 지정된 오토 레이아웃을 무시하고 `aContentView(빨강색)` 크기를 늘린다. (b): 오토레이아웃을 최우선적으로 여겨 `bContentView(파란색)` 의 크기를 늘린다.
    
    정답은 b입니다. 실제로 푸른색의 영역이 늘어난 것을 볼 수 있습니다. 이유는 aContentView의 autolayout이 빨강색의 크기를 조정하지 못하게 하기 때문입니다.  
    
    ![Untitled 4](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/0666bcaf-4eb4-4bf9-81c7-c12bab34f6a6)
    
<br/><br/>

- 마지막으로 `aContentView`, `bContentView` 둘의 사이즈가 정해져 있다면(autoLayout으로) 어떻게 적용될까? 라는 질문입니다.
    
    ```swift
    aContentView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    aContentView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    
    bContentView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    bContentView.widthAnchor.constraint(equalToConstant: 60).isActive = true
    ```
    
    결과부터 보자면 화면에 나오는데 layout 에러가 발생합니다. 읽어보니 width를 60으로 설정했는데 이 autolayout을 깨뜨렸다는 이야기 입니다.
    
    ```bash
    Unable to simultaneously satisfy constraints.
    	Probably at least one of the constraints in the following list is one you don't want. 
    	Try this: 
    		(1) look at each constraint and try to figure out which you don't expect; 
    		(2) find the code that added the unwanted constraint or constraints and fix it. 
    (
        "<NSLayoutConstraint:0x60000210e9e0 UIStackView:0x10260ac80.leading == UILayoutGuide:0x600003b001c0'UIViewSafeAreaLayoutGuide'.leading   (active)>",
        "<NSLayoutConstraint:0x60000210ea30 UIStackView:0x10260ac80.trailing == UILayoutGuide:0x600003b001c0'UIViewSafeAreaLayoutGuide'.trailing   (active)>",
        "<NSLayoutConstraint:0x60000210de50 UIView:0x10400a400.width == 30   (active)>",
        "<NSLayoutConstraint:0x60000210e030 UIView:0x10400aa20.width == 60   (active)>",
        "<NSLayoutConstraint:0x60000210b2a0 'UISV-canvas-connection' UIStackView:0x10260ac80.leading == UIView:0x10400a400.leading   (active)>",
        "<NSLayoutConstraint:0x60000210b840 'UISV-canvas-connection' H:[UIView:0x10400aa20]-(0)-|   (active, names: '|':UIStackView:0x10260ac80 )>",
        "<NSLayoutConstraint:0x60000210b430 'UISV-spacing' H:[UIView:0x10400a400]-(0)-[UIView:0x10400aa20]   (active)>",
        "<NSLayoutConstraint:0x600002125680 'UIView-Encapsulated-Layout-Width' UIView:0x102609940.width == 393   (active)>",
        "<NSLayoutConstraint:0x600002121b80 'UIViewSafeAreaLayoutGuide-left' H:|-(0)-[UILayoutGuide:0x600003b001c0'UIViewSafeAreaLayoutGuide'](LTR)   (active, names: '|':UIView:0x102609940 )>",
        "<NSLayoutConstraint:0x600002120500 'UIViewSafeAreaLayoutGuide-right' H:[UILayoutGuide:0x600003b001c0'UIViewSafeAreaLayoutGuide']-(0)-|(LTR)   (active, names: '|':UIView:0x102609940 )>"
    )
    
    Will attempt to recover by breaking constraint 
    <NSLayoutConstraint:0x60000210e030 UIView:0x10400aa20.width == 60   (active)>
    ```
    
    ![Untitled 5](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/02b6c620-0258-4088-b71c-aa7853873a86)

<br/><br/>

- 왜일까? 라는 질문을 던진다면, 컴포넌트 별로 확인하면 좋을 것 같습니다. StackView의 크기와 컨텐트뷰들의 속성이 정의됩니다. StackView는 autolayout을 잡아주었으니, 무조건 그 크기만큼 할당되어야 합니다.  하지만 StackView의 width와 height은 내부로의 컴포넌트로 정해주는 것이니, 너비에 대한 에러가 발생합니다. component로 계산될 width을 활용하려고 했지만 사용자가 다시 autolayout을 잡아서 이런 일이 발생했습니다.

![Untitled 6](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/86358bac-3339-4ffb-b873-2d35daf387cb)

- 그렇기 때문에  stackVIew의 높이를 결정짓는 Constraint를 완화하게 된다면 다음과 같이 변합니다. 만약 내부 Constraints를 유지하고 싶을 때 에는 stackView의 Distribution을 조정하면 됩니다. UIStackView의 `Distribution`은 `.fill`이  고정이기 때문에, 중간에 공백을 넣고 싶다면 `equalCentering` 혹은 `stackView` 에 아무 기능을 하지 않는 UIVIew를 넣으면 해결 됩니다.

![Untitled 7](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/9bc87871-a082-4b38-b5ff-296a5036ca1d)

![Untitled 8](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/5f30421e-5d9f-4814-a374-9fac6cb64eb9)

<br/><br/>

# 여태 내용 정리

- UIStackView안에 arrangeSubview가 된다면 자동으로 크기가 변경될 수 있다.
- Autolayout은 UIStackView를 통해 크기가 줄어들거나 커지는 것에 대해 우선순위를 갖는다.
- 만약 나머지 공간을 채우고 싶지 않을 때에는 distribution이나 alignment를 fill이 아닌 다른 속성으로 바꾼다.

<br/><br/>

# fill vs fillProportionally 둘이 뭐가 다를까?

### 공식문서에는 다음과 같이 나와있습니다.

**[fillProportionally](https://developer.apple.com/documentation/uikit/uistackview/distribution/fillproportionally):** 뷰는 스택 뷰의 축을 따라 고유한 콘텐츠 크기에 따라 비례적으로 크기가 조정됩니다.

**[fill](https://developer.apple.com/documentation/uikit/uistackview/distribution/fill)**: 배열된 뷰가 스택 뷰에 맞지 않으면 압축 저항 우선순위에 따라 뷰를 축소합니다. 배열된 뷰가 스택 뷰를 채우지 못하면 Hugging 우선순위에 따라 뷰를 늘립니다.

### fillProportionally

UILabel의 경우 텍스트를 입력하면 자동으로 intrinsicContentSize가 지정되게 됩니다. 이를 통해서 실험을 해보겠습니다. aContentLabel과 bContentLabel의 크기를 다르게 조정하여 fillProportionally를 활용하게 된다면 다음과 같은 화면을 볼 수 있습니다. 그리고 이를 출력해보면 다음과 같습니다. 그리고 둘의 크기 비율은 동일합니다. 즉 내부 size 비율을 통해서 StackView 내부에서 커지고 작아진다고 생각할 수 있게 됩니다.

|||
|:-:|:-:|
|![Untitled 9](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/5a5b9d57-2a44-406d-a41e-0699fc54e814)|![Untitled 10](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/9445577e-1d7d-4e35-b8e1-76e669ba8baf)|

```swift
override func viewDidAppear(_ animated: Bool) {
  super.viewDidAppear(animated)
  
  print("view.frame.wdith")
  print("aContentWidth = \(aContentLabel.frame.width), bContentWidth = \(bContentLabel.frame.width)")
  print("aContentWidth / bContnetWidth = \(aContentLabel.frame.width / bContentLabel.frame.width)")
  
  print("\nview.intrinsicContentSize")
  print("aContentWidth = \(aContentLabel.intrinsicContentSize.width), bContentWidth = \(bContentLabel.intrinsicContentSize.width)")
  print("aContentWidth / bContentWidth = \(aContentLabel.intrinsicContentSize.width / bContentLabel.intrinsicContentSize.width)")
}

let aContentLabel: UILabel = {
  let label = UILabel()
  label.text = "에이 컨텐트 라벨"
  label.backgroundColor = .red
  label.textColor = .white
  
  label.translatesAutoresizingMaskIntoConstraints = false
  return label
}()

let bContentLabel: UILabel = {
  let label = UILabel()
  label.text = "비 컨텐트 라벨 () () ()"
  label.backgroundColor = .blue
  label.textColor = .white
  
  label.translatesAutoresizingMaskIntoConstraints = false
  return label
}()

private lazy var testStackView: UIStackView = {
  let st = UIStackView(arrangedSubviews: [aContentLabel, bContentLabel])
  st.backgroundColor = .gray
  st.axis = .horizontal
  st.distribution = .fillProportionally
  st.alignment = .center
  
  st.translatesAutoresizingMaskIntoConstraints = false
  return st
}()
```
<br/><br/>

### fill

위의 fillProportionally를 통해 만든 코드를 fill로 하게 되면 다음과 같습니다. 내부 intrinsicSize에 상관 없이 proportion에 따라서 StackView를 조정하는 것을 볼 수 있습니다. 만약 여기서 `aContnetLabel`의 proportion을 높히면, bContentLabel의 크기가 느는 것을 볼 수 있습니다. 

![Untitled 11](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/4e32e666-8f14-449f-a37d-c5065d2bdc9f)

![Untitled 12](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/d44959de-b1f2-4773-b986-f1de2f485638)

<br/><br/>
## 응용

4 : 6정도의 비율을 가진 a와 b의 ContentView를 만들고 싶어요. intrinsicSize를 같는 CustomUIView를 통해서 접근하면 됩니다다.

```swift
private lazy var testStackView: UIStackView = {
  let st = UIStackView(arrangedSubviews: [aRatioView, bRatioView])
  st.backgroundColor = .gray
  st.axis = .horizontal
  st.distribution = .fillProportionally
  st.alignment = .center
  
  st.translatesAutoresizingMaskIntoConstraints = false
  return st
}()

final class RatioView: UIView {
  let inputIntrinsicContentSize: CGSize
  init(inputIntrinsicContentSize size: CGSize) {
    self.inputIntrinsicContentSize = size
    super.init(frame: .zero)
  }
  required init?(coder: NSCoder) {
    fatalError("not implemented this method")
  }
  override var intrinsicContentSize: CGSize {
    return inputIntrinsicContentSize
  }
}
```

|||
|:-:|:-:|
|![Untitled 13](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/8e817a0e-87c4-4e6f-a609-fb9005b1c47a)|![Untitled 14](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/991ea8ad-a990-40a5-b336-f184bb89d649)|

<br/>
<br/>

### 레퍼런스


[UIStackView.Distribution.fill | Apple Developer Documentation](https://developer.apple.com/documentation/uikit/uistackview/distribution/fill)

[UIStackView.Distribution.fillProportionally | Apple Developer Documentation](https://developer.apple.com/documentation/uikit/uistackview/distribution/fillproportionally)