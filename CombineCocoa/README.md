## 1. 글 작성 개요

“**UIKit은 왜 RxSwift가 Combine보다 좋을까?”에 대한 근본적인 질문부터 시작합니다**.

<br/>

## 2. RxSwift

 `RxSwift`는 모두들 알다 시피 `UIButton`이나 `UISlider` `UITextField`와 같은 위젯에 대해서 `wrapperProperty`를 통해서 접근 가능하게 합니다. 만약 `RxSwift`를 사용한다면 다음과 같이 쉬운 방식으로 `Button`의 이벤트를 `binding`할 수 있습니다.

```swift
button.rx.tap
  .bind {
      print("clicked")
  }
  .disposed(by: disposeBag)
```


`UIButton`이나 다른 `Control`에 관해서 편하게 관리할 수 있다는 이점이 있습니다. 값이 동적으로 바뀔 때 간단하게 `observe`할 수 있습니다. 이는 예전부터 시행된 방식으로 `RxSwift`는 업계표준이 되었다고 할 만큼 채용공고에 우대사항과 자격사항으로 심심치 않게 찾아볼 수 있습니다.

<br/>

## 3. Combine의 등장과 UIKit에서 불편함

`Combine`의 등장은 `ThirdParty`였던 `RxSwift`를 종식시킬수 있을 것이라 생각되었을 것입니다. `Apple`에서 공식으로 제공하는 `Framework`이다 보니, `RxSwift`에 편한 기능들을 UIKit 의 `Component`에 옮길 수 있을 것이라 생각했습니다. 하지만 몇 해를 지나도 그런 일은 일어나지 않았습니다. 이로 인해서 `UIKit`에서 `RxSwift`처럼 쉽게 `UIButton`에 옵저빙을 하는 것에 대해서 다른 코드들이 필요하게 되었습니다. 이렇게 다른 부수적인 작업들 때문에 UIKit에 Combine은 불편하다 라는 인식이 전반적으로 깔린 것 같습니다.

<br/>

## 4. 이제는 RxSwift → Combine

2023년 현재 많은 회사들이 자격 요견으로 `SwiftUI`라는 기술을 우대조건을 걸고 있습니다. 또한 `RxSwift`의 우대사항 옆에 항상 `Combine`에 관한 문구 또한 따라다니게 되었습니다. 근본적인 질문으로 다시 회귀하게 되면, 왜 불편하다는 `Combine`을 굳이 `UIKit`의 활용해야 할까요? 이는 두가지 이유가 있다고 생각합니다.

1. RxSwift보다 더 좋은 성능
2. SwfitUI로 혼용 혹은 전환

많은 팀들이 `UIKit`과 `SwfitUI`를 혼용 혹은 `SwiftUI`로 전환할려는 노력을 한다고 들었습니다. 그렇게 된다면 사실상 `RxSwift`와 `Combine`을 혼용하여 활용하게 되는 것이 통일성 측면에서 나쁘게 느껴질 것입니다.

<br/>

## 5. Combine은 UIKit에서 어떻게 불편한 것인가?

처음 질문은 다음과 같이 시작합니다. **어떻게 불편한 것이지?** 실제 코드로 보겠습니다. 다음은 `NotificationCenter`를 활용한 `Publisher` 코드 입니다. UITextField.textDidChangeNotification의 Notification에 대한 Publisher를 만드는 것 입니다. 이는 필연적으로 `NotificationCenter`을 거쳐야 된다는 단점이 있습니다. (동기로 진행된다던가, 전역적으로 사용하는 `NotificationCenter`를 사용해야할까 라던가…) 또한 모든 `UIControl.Event`를 `NotificationCenter`에서 처리할 수 없습니다.

```swift
 NotificationCenter.default
    .publisher(for: UITextField.textDidChangeNotification, object: self)
    .map { ($0.object as? UITextField)?.text  ?? "" }
    .eraseToAnyPublisher()
```

<br/>

## 6. CombineCocoa란

이로 인해서 CombineCocoa라는 독자적 라이브러리를 고민하게 되었습니다. 코드는 단순합니다. 

### (1). `publisher` 함수 정의

먼저 `publisher`를 정의합니다. 이 함수는 `UIControl.Event`에 따라 동작하는 함수 예정입니다.

1. `UIControl`에 `Extension`하여 사용할 수 있게 합니다.
    
    eg) `button.pbulisher(.touchupInside)`
    
2. 그 다음 `EventPubilsher`라는 것을 리턴하게 됩니다. 이 `EventPublisher`는 `Publisher Protocol`을 채택합니다.

```swift
extension UIControl { // (1)
  func publisher(_ control: UIControl.Event) -> EventPublisher {
    return EventPublisher(control: self, event: control) // (2)
  }
}
```

<br/><br/>


### (2). Publisher를 채택한 EventPublisher

위 함수에서 리턴하는 `EventPublisher`를 새로 생성합니다. `Publisher`의 `Protocol`을 채택하기 위해서 몇가지 준비가 필요합니다. 

(1) 가장 기본적인 `output`과 `failure`를 생성하는 부분입니다. 내보내는 값이 `UIControl` 입니다. 왜냐하면 우리가 `Publisher`할 객체는 `Event`가 아니라 `Event`를 내보내는 `UIControl`입니다. 또한 `Output`은 가장 기본적으로 널리 사용되는 `Never`로 처리했습니다.

(2) 그리고 각 `UIControl` 과 `UIControl.Event`를 내부 `property`로 생성합니다. 이렇게 생각한 이유는 `Subscription`이 `Publisher`로 부터 `Subscriber`에게 `Event`가 있을 때 값을 전달해야하기 때문입니다. 정리하자면 `publisher`가 값을 `emit`할 때 `Subscriber`가 값을 받기 위해서 `subscription`이 필요하게 됩니다. 이 `Subscription`에서 `addtarget`을 통해서 특정 이벤트가 발생 할 시 `subscriber`에게 값을 전달 하려 합니다.

```swift
struct EventPublisher: Publisher {
  func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, UIControl == S.Input {
    let subscription = EventSubscription(control: control, event: event, subscriber: subscriber)
    subscriber.receive(subscription: subscription)
  }
  
//(1)
  typealias Output = UIControl
  typealias Failure = Never
//(2)
  let control: UIControl
  let event: UIControl.Event
}
```

<br/><br/>

### (3) Subscription을 채택한 EventSubscription

EventSubscription을 통해서 UIControl에서 Event가 발생하게 된다면 subscriber 에게 값을 전달(receive)합니다. 이 때 전달하는 값은 UIControl입니다.

<img width="1436" alt="Untitled" src="https://github.com/boostcampwm2023/iOS08-WeTri/assets/56383948/f2d6f1c1-a85a-43d5-afc6-0543f86113d9">

(2) property를 먼저 보게 되면 UIControl 과 event 그리고 subscriber를 가지고 있습니다.

(3) control부분에서 addTarget을 통해서 [Event](https://developer.apple.com/documentation/uikit/uicontrol/event)가 발생하게 되면 subscriber의 receive를 호출합니다.

eg) `touchUpInside`, `toucupOutside`, `editingDidEnd` 

(1) 만약 cacnel되면 순환참조를 일으킬 수 있는 subscriber을 nil로 바꾸고 removeTarget을 통해 eventDidOccur

```swift

class EventSubscription<EventSubscriber: Subscriber>:
  Subscription where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {
//(1)
  func cancel() {
    subscriber = nil
    control.removeTarget(self, action: #selector(eventDidOccur), for: event)
  }
  func request(_ demand: Subscribers.Demand) { }
 
//(2)
  let control: UIControl
  let event: UIControl.Event
  var subscriber: EventSubscriber?

  @objc func eventDidOccur() {
    _ = subscriber?.receive(control)
  }
  
//(3)
  init(control: UIControl, event: UIControl.Event, subscriber: EventSubscriber) {
    self.control = control
    self.event = event
    self.subscriber = subscriber
    
    control.addTarget(self, action: #selector(eventDidOccur), for: event)
  }
}
```

<br/><br/>

### (4) 활용

UIControl을 상속받은 객체에 한해서 접근하여 사용할 수 있습니다. publisher(UIControl.Event)로 접근하여 편하게 사용하면 됩니다. 이 때 뱉는 값은 UIControl 스스로 입니다. 이를 적절한 Operator을 활용하여 값을 변환하면 됩니다.

- 다음과 같이 Event에 대해서 활용할 수 있습니다.
    
    ```swift
    titleButton
      .publisher(.touchUpInside)
      .sink { [weak self] _ in
    		dump("버튼이 눌렸습니다.")
      }
      .store(in: &cancell)
    ```
    

<img width="332" alt="Untitled 1" src="https://github.com/boostcampwm2023/iOS08-WeTri/assets/56383948/98cae152-14fa-411e-b766-c229490d5ca2">

<img width="460" alt="Untitled 2" src="https://github.com/boostcampwm2023/iOS08-WeTri/assets/56383948/5a380d58-cd7e-42a7-9656-4fdcfad2bffa">


- 우리가 자주 활용하는 TextField에 대한 예제를 보겠습니다.
    
    compactMap을 통해서 uitextField로 변환하여 사용할 수 있습니다.
    
    ```swift
    customTextField
    	.publisher(.editingChanged)
    	.compactMap{($0 as? UITextField)?.text}
    	.sink { _ in } receiveValue: { str in
    	  dump("텍스트필드 벨류는 = \(str)")
    	}
    	.store(in: &cancell)
    ```
    
<img width="470" alt="Untitled 3" src="https://github.com/boostcampwm2023/iOS08-WeTri/assets/56383948/4d066dad-4446-4369-af74-8e77aff04045">

<br/><br/>

## 7. 결론

한번 구현하면, 생각보다 쉽게 사용할 수 있습니다. extension을 통해서 각각의 tapPublisher나 textValueChangePublisher 등등 다양하게 코드를 확장할 수 있습니다. 그러면 안녕~~

### 레퍼런스

[[Combine] UIKit에서 Combine 편하게 쓰기](https://velog.io/@aurora_97/Combine-UIKit에서-Combine-편하게-쓰기)

[Combine with UIControl](https://medium.com/@utvik/combine-with-uicontrol-dc1c89225866)

[Combine | Apple Developer Documentation](https://developer.apple.com/documentation/combine)

[Publisher | Apple Developer Documentation](https://developer.apple.com/documentation/combine/publisher)

[Subscription | Apple Developer Documentation](https://developer.apple.com/documentation/combine/subscription)

[UIControl.Event | Apple Developer Documentation](https://developer.apple.com/documentation/uikit/uicontrol/event)
