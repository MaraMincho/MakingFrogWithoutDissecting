
# Weak Dictionary? Does iOS have Garbage Collection?

## 개요
WeakDictionary를 어떻게 만들까요에 대한 궁금중에서 출발합니다.

<br/><br/>

## Dictionary에 대한 기초

보통 우리가 Dictionary를 만들 때 다음과 같이 작성합니다. 많이 사용해보신 분들은 아시겠지만 Dictionary의 Key값이 되기 위한 조건은 Hashable 이라는 protocol을 만족해야 합니다. Hashable이라는 Protocol은 `==`의 Operator와 `hash(into:)`의 매서드를 구현을 통해 완성합니다. 자세한 설명은 [Hashable 문서를 참조하시면 좋을 것 같습니다.](https://developer.apple.com/documentation/swift/hashable)






<br/><br/><br/>

## Collection Type
우리는 Dictionary를 보기 전 스위프트의 `Collection Types`에 대해서 알아야 합니다. Collection Type의 특징이라면 모두 Value Type으로 되어있습니다. 그렇기 떄문에 매개변수로 전달되거나 `return`으로 전달되었을 때 refrence가 아니라 조심해야한다는 점 입니다. 그리고 Value타입이기 때문에, 다른 언어에 비해 `Side Effect`가 적다는 것도 장점입니다.

<br/><br/><br/>

## Strong Refrence
만약 해시를 `var viewControllerDictionary:[ UIViewController: Int] = [:]`과 같이 만들었다고 가정해 봅니다. 이 viewControllerHash가 AppDelegate나 SceneDelegate에서 관리되고 있다고 생각해 봅시다. 그리고 ViewController를 생성할 때 마다 viewControllerDictionary 값이 업데이트 된다고 생각해 봅시다. `viewControllerDictionary`가 `UIVIewController`를 key값으로 강하게 참조하고 있습니다. 그렇기 때문에 `dismiss`되거나 `pop`되었을 때도 강한 참조 덕에 메모리에서 해제되지 않습니다.


```swift
// SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  var viewControllerDictionary:[UIViewController: Int] = [:]
  //...

}
```
<br/><br/><br/>






## Automatic Reference Counting
위와 같이 강한 참조 덕에 메모리에서 해제되지 않는 이유는 Automatic Refrence Counting(이하 ARC) 이라는 것 때문입니다. 이 ARC라는 것은 메모리를 지속적으로 관리하여서, 사용자가 메모리에 대한 걱정을 하지 않도록 하기 위해 만들어 졌습니다.

### ARC작동 방식
클래스 객체를 생성할 때, ARC는 메모리 인스턴스를 저장할 Chunk를 할당합니다. 메모리는 타입을 포함하여 `StoreProperty`에 관련한 값들을 갖고 있습니다. <br/>
만약 더이상 객체 인스턴스가 필요가 없어지면 ARC는 메모리를 free up 합니다.(그 메모리를 다른 목적의 인스턴스가 쓰일 수 있도록) ARC는 RefrenceCount가 사라진 객체 인스턴스에 한해 계속적으로 인스턴스를 free up 합니다. 객체를 참조하고 있는, 혹은 저장하게 된다면 (강하게) 객체의 refrenceCount는 올라가고, 참조를 포기하게 되면 refrenceCount는 감소하게 됩니다. 다음과 같이 Person의 경우를 보게 되면, reference를 서로 강하게 참조하게 되버려 ARC가 메모리 해제를 하지 않습니다. 

```swift
var reference1: Person?
var reference2: Person?
var reference3: Person?

reference2 = reference1
reference3 = reference1
reference1 = nil
reference2 = nil

reference3 = nil // Prints "deinit"

```


### [Garbage collection vs ARC](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting)
가비지 컬렉션과 ARC는 닮아 있습니다. 어쩄거나 저쩄거나 Memory를 비워준다는 것에 대해서 공통점을 갖는 것 처럼 보입니다. 하지만 근본적으로 다른 이유가 있는데, 그것은 가비지 컬렉션이 `runtime`에 특정 트리거를 통해서 호출되어서 메모리를 비우는 반면 ARC는 마지막 강한 참조가 제거되자마자 refrenceCount가 0인 객체를 모두 deinit시킵니다. 그래서 객체를 비우는 순간 refrenceCount가 0이면 그 즉시 해제됩니다. 다시 말하면 GC는 RunTime동안 이고, ARC는 RealTime의 속성을 갖습니다.





<br/><br/>


## 그러면 타입이 같은 객체를 저장하기 위해서는 무조건 strong인가?
접답은 YES입니다. 타입이 같은 객체를 저장함으로서, 강한 참조가 이루어지게 됩니다.(`Collection Type`이 `ValueType`) 하지만, 다른 방법도 있었습니다. 그것은 **NSMapTable입니다**. 

<br/><br/>

## Weak Key Dictionary "NSMapTable"

NSMapTable에 대한 설명입니다. 이는 공식문서가 아닌, `XCode Depth`를 통해서 확인할 수 있습니다. 





>An NSMapTable is modeled after a dictionary, although, because of its options, is not a dictionary because it will behave differently.  The major option is to have keys and/or values held "weakly" in a manner that entries will be removed at some indefinite point after one of the objects is reclaimed.  In addition to being held weakly, keys or values may be copied on input or may use pointer identity for equality and hashing.<br/>An NSMapTable can also be configured to operate on arbitrary pointers and not just objects.  We recommend the C function API for "void *" access.  To configure for pointer use, consult and choose the appropriate NSPointerFunction options or configure and use  NSPointerFunctions objects directly for initialization. "

>NSMapTable은 Dictionary을 본떠서 만들어졌지만, Option 때문에 Dictionary 다르게 동작하기 때문에 Dictionary가 아닙니다. 주요 옵션은 키 및/또는 값을 "약하게" 유지하는 것인데, 이는 개체 중 하나를 회수한 후에 어떤 무기한 지점에서 항목이 제거됩니다. 키 또는 값을 약하게 유지하는 것 외에도 입력 시 복사하거나 등호 및 해싱을 위해 포인터 ID를 사용할 수 있습니다.
NSMapTable은 개체뿐만 아니라 임의의 포인터에서 작동하도록 구성할 수도 있습니다. "void *" 접근을 위해 C function API를 권장합니다. 포인터 사용을 위해 구성하려면 적절한 NSPointerFunction 옵션을 선택하거나 초기화를 위해 NSPointerFunctions 개체를 직접 구성하여 사용하십시오.<br/>

<br/>
공식문서에 쓰여있지 않은 정보는, 해제되는 시점이었습니다. 우리가 Key값을 weak하게 가져갈려 합니다. 그리고 그 Weak 한 Key가 해제되었을 때 바로 Dictionary의 Value가 해제 될 것이라 예상합니다. 하지만, 문서에 기재되어 있듯이 바로 해제되지 않습니다. 이는 우리가 아는 부분과 상충되는 것이 있습니다. iOS에는 ARC가 있어서 자동으로 메모리를 관리해주는데 GC처럼 특정 어느 시점에서(트리거) 메모리가 해제된다는 말 입니다. 여기서 한가지 의문점을 도출 할 수 있습니다. **iOS에서도 GC가 있을까?**

<br/><br/>














## iOS에서 GC가 있을까? Does iOS have Garbage Collection?
정답은 NO라고 생각합니다.(추측) Apple 공식적으로 GC말고 ARC 활용한 메모리 관리를 하기 때문에 사용하지 않는다고 생각합니다. 위의 NSMapTable이 해제되는 시점은 GC의 Triger가 아닌 특정 운영체제의 Triger라고 생각합니다.







## NSMapTable활용

어떤 값을 약한 참조를 할지는 조건에 생성자를 통해서 정의할 수 있습니다. <br/>
`public init(keyOptions: NSPointerFunctions.Options = [], valueOptions: NSPointerFunctions.Options = [], capacity initialCapacity: Int)` <br/> 
[이는 공식문서에 상세하게 나와 있습니다.](https://developer.apple.com/documentation/foundation/nspointerfunctions/options) key value둘다 weak 혹은 key 만 string, value만 strong하게 만들 수 있고, 또한 다양한 옵션들을 설정할 수 있습니다.

그리고, 이 MapTable을 활용하여 값을 할당할 수 있습니다. 특이한 점은 `subscription이` 아닌 `func`로만 key value로 할당하거나,key 를 통해 value를 얻을 수 있습니다.



```swift
final class foo {}
final class bar {}
var mapTable: NSMapTable<bar, foo> = .weakToStrongObjects()
mapTable.object(forKey: Bar?)
mapTable.setObject(foo?, forKey: bar?)
```




<br/><br/>




## 실제 ARC가 안되는 스크린샷
UIViewController가 해제되었을 때 내부, UIViewController의 내부에 키값인 `UIImageView(key)`는 해제되었지만 `value`값인 `FetchDescriptionProperty(value)`가 즉각적으로 해제되어지지 않았습니다.

```swift
var targetViewAndFetchProperty: NSMapTable<UIImageView, FetchDescriptionProperty> = .weakToStrongObjects()
```


![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/f86602df-b077-41bb-b6ff-dad12f376a37)






<br/><br/>





### 참고 문헌
- https://developer.apple.com/documentation/swift/hashable)

- https://docs.swift.org/swift-book/documentation/the-swift-programming-language/collectiontypes/


- https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwjduMH18a-EAxXO3TQHHRb0C6cQFnoECBMQAQ&url=https%3A%2F%2Fdeveloper.apple.com%2Fdocumentation%2Fswift%2Fdictionary&usg=AOvVaw0Vks6O3dHmbcNGrUOpQDpv&opi=89978449

- https://developer.apple.com/documentation/foundation/nsmaptable

- https://docs.elementscompiler.com/Concepts/ARCvsGC/

- https://developer.apple.com/documentation/foundation/nsmaptable

- https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting#Strong-Reference-Cycles-for-Closures

- https://docs.swift.org/swift-book/documentation/the-swift-programming-language/memorysafety

- https://developer.apple.com/documentation/foundation/nspointerfunctions/options