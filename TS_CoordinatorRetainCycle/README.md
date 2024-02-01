# Coordinator 트러블 슈팅

<br/><br/>

## 개요 
뷰 게층은 위에서 아래로 떨어집니다. 이것이 subViews를 통해서 일수도 있고, NavigationController를 통해서 Push 혹은 ViewController의 Present방식을 통해서 Depth가 깊어집니다. 우리는 때때로 순차적으로 ViewController를 해제하여 Depth를 줄이는 것이 아닌 바로 줄이고 싶은 경우가 있습니다. 이럴 때 어떤 방식을 활용하는것이 좋을까에 대해서 고민해본점을 설명하려 합니다.

<br/><br/>

## Coordinator를 구현할 때 Flow라는 변수를 구현
코디네이터 하나가 꼭 하나의 뷰컨트롤러만 만들어야 할까 부터 시작합니다. 어떤 경우는 순서가 보장되었을 때도 있습니다. 예를 들어서 글쓰기와 사람을 태그하는 화면은 순차적으로 무조건 진행될 수 있습니다. 이를 각각의 다른 코디네이터에서 뷰를 생성 및 Push나 Present하는 구조는 코디네이터 이전보다 복잡해 질 수 있습니다. 그래서 몇가지의 뷰들을 Flow로 묶어서 처리하는 방법입니다. 코디네이터에서 **Child를 통해서** Flow 조건에 따라 Coordaintor를 pop할 수 있습니다. Flow라는 Enum을 구현하게 된다면 현재 뷰 혹은 Coordinator가 어떤 Flow인지 명확해 집니다. 

![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/32ad21ef-035d-48a6-b98a-92ffecc042a2)

<br/><br/>

## 삭제 용이
이렇게 된다면, Nvaigation에서 삭제에 용이하다는 장점이 있습니다.예를 만들었던 코디네이터에서 ProfileFlow 관한 것들을 모두 제거하라는 명령을 할 수 있습니다.(Profile이 수정되어서 서버에서 다시 받아와야 하는 경우를 상상하시면 좋을 것 같습니다.) 그림에서 보는것과 같이 세게의 NavigationController Depth에 ProfileFlow가 많이 있습니다. 만약 Profile Flow 를 제거하고 싶다면, `ChildCoordaintors`에서 `flow Property` 가 `Profile`인 경우만 제거하면 됩니다. 이를 코드를 통해서 보여주자면 다음과 같습니다.

<br/>

![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/d5b378d9-67db-407f-bbfc-bb1b9a0d02b7)


```swift
enum Flow {
  case profile
  case home
  case writing
  case tabBar
  case feed
}

protocol Coordinating: AnyObject {
  func start()
  var parent: Coordinating? { get }
  var navigationController: UINavigationController? { get }
  var childCoordinators: [Coordinating] { get set }
  var flow: Flow { get }
}

extension Coordinating {
  func pop(flow: Flow) {
    childCoordinators.forEach { child in
      child.pop(flow: flow)
    }
    let notProfileFlowChild = childCoordinators.filter{$0.flow != .profile}
    childCoordinators = notProfileFlowChild
  }
}

final class HomeCoordinator: Coordinating {
  let flow: Flow = . tabBar
  
  func start() {
    navigationController?.pushViewController(makeTapBarController(), animated: false)
  }
  func makeTapBarController() -> UITabBarController {
    return .init()
  }
  
  weak var parent: Coordinating?
  
  weak var navigationController: UINavigationController?
  
  var childCoordinators: [Coordinating] = []
  
  init(parent: Coordinating, navigationController: UINavigationController) {
    self.parent = parent
    self.navigationController = navigationController
  }
}

extension HomeCoordinator {
  func removeFeedFlow() {
    pop(flow: .feed)
    navigationController?.popToRootViewController(animated: true)
  }
}

```

<br/>

## 개인적인 생각
이런식으로 Flow를 나누는 것에 대해서 나쁘지는 않다고 생각합니다. 대게 많은 뷰컨트롤러를 한개의 Coordinator로 나누는 경우가 있는데, 이는 화면전환이 많은 앱 입니다. 화면전환이 많지 않은데 Coordniator를 쓴다면 Flow도 고려하면 좋을 것 같습니다. 물론 화면전환을 용이하게 하려고 Coordinator를 쓴다지만 재사용 측면을 바라봐도 좋은 것 같습니다.

다음 포스팅은 Coordinator에서 발생한 Retain Cycle을 설명하려 합니다.