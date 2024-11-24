Swift 6에서 Sendable은 단순한 프로토콜이 아닙니다. 동시성이 안전한 코드베이스를 유지하는 데 핵심적인 역할을 합니다. 본질적으로 Sendable은 컴파일 타임 검사를 통해 태스크 경계 간의 데이터 안전성을 보장하는 Swift의 방법입니다. Sendable의 진정한 가치는 어떤 타입이 태스크 간에 공유될 수 있는지를 제한하고, 동시 접근에 안전하지 않은 가변 타입에 플래그를 지정하며, 개발자들이 더 안전한 패턴을 사용하도록 유도하는 데 있습니다. 저자는 이러한 개념을 깊이 이해하는 것이 기술 면접에서 매우 도움이 되었다고 합니다. Sendable이 스레드 안전성을 어떻게 보장하는지 설명할 수 있는 능력은 현대 Swift 개발 경험을 보여주는 데 큰 도움이 되었다고 합니다.


### 동시성 컨텍스트에서 Sendable이 중요한 이유
Swift가 Task.init { } 또는 async 메서드를 호출할 때와 같은 태스크 경계를 감지하면, 동기화되지 않은 동시 변경으로부터 안전한지 확인하기 위해 전달되는 모든 객체를 평가합니다. Sendable은 타입이 스레드 간에 안전하게 전송될 수 있다는 것을 인증하는 컴파일 타임 계약 역할을 함으로써 이러한 평가를 가능하게 합니다. 이는 구조체와 같은 단순한 데이터뿐만 아니라 안전하지 않은 참조가 숨어있을 수 있는 복잡한 중첩 타입에도 영향을 미칩니다.


예를 들어, 가변 배열을 포함하는 구조체를 살펴보겠습니다:

```swift
struct ExampleData: Sendable {
    var values: [Int]
}
```
values가 가변적이고 적절한 격리 없이 서로 다른 태스크 간에 공유된다면 예기치 않은 동작이 발생할 수 있습니다. ExampleData를 Sendable에 준수하게 함으로써 컴파일러는 values가 동시에 수정될 수 없도록 보장하여 태스크 경계에서 안전하게 사용할 수 있게 합니다.

### Sendable 프로토콜 심층 분석
컴파일러 강제: Swift 컴파일러는 Sendable을 사용하여 컴파일 타임에 스레드 안전성을 검증합니다. 오류가 발생하기 쉽고 반응적인 런타임 검사와 달리, 컴파일 타임 검사는 많은 동시성 버그를 사전에 제거합니다. Swift 6는 프로토콜 준수와 타입 수준 제한의 엄격한 시스템을 사용하여 이를 구현합니다.
예를 들어, 가변 프로퍼티를 포함하는 클래스와 같은 Sendable이 아닌 타입을 태스크 경계를 넘어 전달하려고 하면 컴파일러는 "Type 'MyClass' does not conform to Sendable"와 같은 오류를 생성합니다. 이 오류는 즉각적인 피드백을 제공하여 런타임 전에 스레드 안전성 문제를 해결할 수 있게 해주며, 이는 동시성 관련 버그의 가능성을 크게 줄입니다.


명시적 준수: Sendable을 자동으로 만족시키지 않는 복잡한 타입의 경우 명시적으로 준수해야 합니다. 이는 클래스 프로퍼티를 불변으로 표시하거나 가변 프로퍼티를 액터로 래핑하는 것을 포함합니다. 타입을 Sendable에 준수시킬 때는 정확해야 합니다 - 중첩된 타입을 확인하고, 가변 프로퍼티가 있는 경우 불변성 보장을 우회할 수 있는 서브클래싱을 방지하기 위해 클래스를 final로 표시하는 것을 고려해야 합니다.

예를 들어, 가변 상태를 포함하는 클래스를 살펴보겠습니다:

```swift
final class UserData: Sendable {
    let name: String
    let age: Int
    private let accessQueue = DispatchQueue(label: "UserDataAccess")
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
```

데이터가 적절한 격리 없이 동시에 접근된다면 레이스 컨디션이나 데이터 손상이 발생할 수 있습니다. 클래스를 final로 표시하고 Sendable 준수를 보장함으로써 컴파일러는 데이터가 태스크 경계에서 안전하지 않게 접근될 수 없도록 보장하여 안전한 메모리 의미론을 강제합니다.


### SwiftUI 애플리케이션에서의 Sendable 고급 사용 패턴
SwiftUI의 상태 관리를 활용하는 애플리케이션에서 Sendable은 더욱 중요해집니다. SwiftUI 뷰는 종종 비동기 소스에서 데이터를 받기 때문에 데이터가 태스크 경계를 넘어 비동기적으로 뷰를 업데이트해야 할 수 있습니다. 이러한 소스가 Sendable로 표시되면 Swift는 복잡한 상태 기반 애플리케이션에서도 안전성을 보장할 수 있습니다.

예를 들어, 원격 API에서 날씨 데이터를 가져와서 표시하는 SwiftUI 뷰를 상상해보세요. WeatherViewModel은 새로운 데이터가 비동기적으로 사용 가능해질 때 뷰를 업데이트해야 할 수 있습니다. WeatherViewModel을 Sendable로 표시함으로써 날씨 데이터를 가져오고 업데이트하는 모든 비동기 태스크가 동시성에 안전하도록 보장하여 UI가 여러 태스크에서 업데이트될 때 레이스 컨디션이나 데이터 손상과 같은 문제를 방지합니다.

### 클로저에서 @Sendable 사용하기
Swift 6에서는 클로저에 @Sendable을 표시할 수 있어 Sendable이 아닌 참조를 캡처하지 못하도록 제한합니다—이는 미묘하지만 강력한 안전 기능입니다. 예를 들어, 가변 배열을 참조하는 클로저가 있다면, @Sendable로 표시하면 컴파일러가 이 배열이 동시에 수정되지 않도록 보장합니다. @Sendable 클로저를 사용하면 개발자가 외부 캡처를 의식하도록 강제하여 의도하지 않은 공유 상태의 위험을 최소화합니다.
```swift
func performNetworkTask(action: @Sendable () async -> Void) {
    Task {
        await action()
    }
}
```
@Sendable 클로저를 사용하면 스레드 안전하지 않은 객체의 캡처를 방지할 수 있습니다. 이는 클로저가 공유 상태나 참조 타입을 포함할 때 중요한 고려사항입니다.

### Sendable 준수를 위해 공유 가변 상태를 액터로 래핑하기


액터는 Sendable이어야 하는 가변 상태를 처리하는 좋은 방법을 제공합니다. 앱의 여러 부분에서 가변 상태를 공유하는 객체(예: 캐시나 세션 핸들러)를 만드는 경우 액터를 사용하여 Sendable로 만들 수 있습니다.

예를 들어, 액터와 시리얼 디스패치 큐를 사용하는 전통적인 클래스의 차이를 살펴보겠습니다:

```swift 
// 시리얼 디스패치 큐를 사용하는 클래스
final class SharedCacheWithQueue {
    private var cache: [String: Data] = [:]
    private let accessQueue = DispatchQueue(label: "SharedCacheAccess")

    func storeData(_ data: Data, forKey key: String) {
        accessQueue.sync {
            cache[key] = data
        }
    }

    func fetchData(forKey key: String) -> Data? {
        return accessQueue.sync {
            cache[key]
        }
    }
}

// 동일한 공유 캐시를 관리하는 액터 사용
actor SharedCache: Sendable {
    private var cache: [String: Data] = [:]

    func storeData(_ data: Data, forKey key: String) {
        cache[key] = data
    }

    func fetchData(forKey key: String) -> Data? {
        return cache[key]
    }
}
```

액터(SharedCache)를 사용하면 코드가 단순화되고 동기화를 수동으로 관리할 필요 없이 스레드 안전성이 보장되어 동시 환경에서 가변 상태를 처리하는 데 더 효과적인 선택이 됩니다.


### @Observable, SwiftUI, 그리고 Sendable의 깊은 통합
Swift 6에서는 @Observable이 ObservableObject를 대체하여 더 효율적이고 타입 안전한 프로퍼티 관찰을 제공합니다. Sendable과 결합하면 @Observable은 상태 격리를 강제하고 반응형 환경에서 자동 UI 업데이트를 용이하게 함으로써 SwiftUI 애플리케이션에 추가적인 동시성 안전성 계층을 추가합니다.


예를 들어, 날씨 데이터를 비동기적으로 업데이트하는 WeatherViewModel이 있다면, @Observable을 사용하면 프로퍼티가 타입 안전한 방식으로 업데이트되는 동시에 동시 수정으로부터 격리되도록 보장합니다. 이러한 조합을 통해 SwiftUI 뷰가 데이터 레이스나 일관성 없는 UI 상태의 위험 없이 상태 변경에 안정적으로 반응할 수 있습니다.


### Sendable 타입에서 @Observable 활용하기

@Observable을 사용하면 뷰 모델이 @Published 프로퍼티를 명시적으로 필요로 하지 않고도 SwiftUI의 반응성 이점을 얻을 수 있습니다. 하지만 @Observable 타입이 태스크 간에 공유될 때는 Sendable 규칙을 따라야 한다는 것을 기억하세요. @Observable 타입이 비동기 컨텍스트 간에 공유되는 가변 데이터를 포함한다면 Sendable을 준수하도록 해야 합니다.


```swift 
@Observable
final class WeatherViewModel: Sendable {
    var weatherData: WeatherData?

    func fetchWeather() async {
        do {
            weatherData = await fetchDataFromServer()
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    private func fetchDataFromServer() async -> WeatherData {
        return WeatherData(temperature: 70.0, condition: "Cloudy")
    }
}
```

### Sendable 관련 동시성 문제 디버깅

컴파일러 진단 및 오류:

컴파일러는 Sendable이 아닌 타입에 대해 즉각적인 피드백을 제공합니다. 예를 들어, Sendable이 아닌 타입을 async 함수에 실수로 전달하면 Swift는 일반적으로 "Type X does not conform to Sendable"를 참조하는 명확한 오류로 플래그를 지정합니다. 이러한 오류는 사전에 타입 안전성을 강제하는 데 도움이 됩니다.
Swift의 동시성 디버깅 도구는 단순한 오류를 넘어섭니다. 다음과 같은 도구와 기술이 있습니다:
Thread Sanitizer (TSAN):

Xcode의 Product > Scheme > Edit Scheme > Diagnostics에서 Thread Sanitizer를 켤 수 있습니다.
이 도구는 런타임에 레이스 컨디션을 동적으로 감지하며, 특히 여러 액터나 태스크가 공유 데이터에 접근할 때 유용합니다.

예를 들어, TSAN은 여러 비동기 태스크가 동시에 동일한 변수를 수정하려고 시도하는 경우를 식별하여 미묘한 버그를 예방하는 데 도움이 되는 통찰력을 제공합니다.

### 브레이크포인트 격리 확인:
액터를 사용할 때 메서드 내에 브레이크포인트를 설정하여 격리된 실행 컨텍스트를 확인할 수 있습니다.
예를 들어, 액터의 메서드 내에 브레이크포인트를 설정하여 한 번에 하나의 태스크만 가변 상태에 접근하고 있는지 확인할 수 있습니다.

태스크별 실행을 추적하고 액터 내의 가변 프로퍼티가 예기치 않게 접근되지 않도록 보장합니다.

### 상세한 태스크 트레이스백:
비동기 함수에 브레이크포인트를 설정하여 Swift의 비동기 백트레이스를 사용하면 태스크 실행 경로를 추적할 수 있습니다.

예기치 않은 태스크 실행 순서가 발생하거나 레이스 컨디션이 의심되는 경우 특히 유용합니다.

예를 들어, 비동기 함수 내에 브레이크포인트를 설정하면 태스크 실행 순서를 검사할 수 있어 태스크가 예상 순서를 벗어나서 실행되거나 여러 태스크가 잘못 상호작용하는 지점을 파악하는 데 도움이 됩니다.


### Swift 6에서 태스크 실행 분석

Swift 6는 태스크와 그 실행 상태에 대한 새로운 수준의 가시성을 도입합니다. Task.currentPriority와 다른 태스크 메서드를 사용하여 태스크가 어떻게 우선순위가 지정되는지, 잠재적인 병목 현상이나 의도하지 않은 동작이 발생할 수 있는 위치를 평가할 수 있습니다. Swift 6에서 동시성 문제를 디버깅하려면 태스크 계층과 그들이 어떻게 상호작용하는지에 대한 세밀한 이해가 필요합니다.

```swift 
Task {
    print("Current Task Priority: \(Task.currentPriority.rawValue)")
    await someConcurrentFunction()
}
```

태스크 우선순위에 대한 통찰력을 사용하면 어떤 태스크가 예기치 않게 낮은 우선순위를 가져 성능에 영향을 미칠 수 있는지 평가하는 데 도움이 됩니다.

## Swift 6에서 Sendable 사용 시 흔한 함정과 이를 피하는 방법

### @Sendable 클로저에서의 의도하지 않은 캡처:

가장 흔한 함정 중 하나는 @Sendable 클로저 내에서 실수로 가변 상태를 캡처하는 것입니다.
캡처를 두 번 확인하고 스레드 안전성을 보장하기 위해 가능한 경우 값 타입이나 불변 복사본을 사용하는 것을 고려하세요.

@Sendable 속성을 클로저에 사용하여 의도하지 않은 메모리 공유를 방지하고 캡처된 변수가 동시에 사용하기에 안전한지 확인하세요.


### Sendable 클래스의 가변 참조 타입:
가변 프로퍼티가 있는 클래스를 사용할 때는 주의해야 합니다.
다른 태스크로 전달된 가변 참조는 쉽게 데이터 손상으로 이어질 수 있습니다.
이를 피하기 위해 공유된 가변 상태가 액터를 사용하거나 불변 복사본을 사용하여 적절히 격리되도록 보장하세요.
Sendable 준수가 필요한 클래스는 일반적으로 서브클래싱을 제한하고 가능한 경우 불변성을 보장하기 위해 final이어야 합니다.


### SwiftUI 뷰에서 Sendable이 아닌 타입 사용:
SwiftUI 뷰 자체는 Sendable이 아니며, 이는 뷰 인스턴스를 태스크 경계를 넘어 전달하려고 할 때 문제가 될 수 있습니다.
예를 들어, Text나 VStack 인스턴스를 직접 태스크 간에 전달하려고 하면 이들이 Sendable이 아니기 때문에 컴파일러 오류가 발생합니다.
대신 뷰 구성을 공유해야 하는 경우, 직접적인 뷰 인스턴스 대신 불변 구성이나 Sendable 상태 객체를 전달하세요.
이렇게 하면 공유되는 데이터가 동시 사용에 안전하도록 보장하여 잠재적인 런타임 충돌이나 불일치를 방지할 수 있습니다.


## 결론
Sendable을 통해 Swift는 컴파일 타임에 높은 수준의 동시성 안전성을 강제합니다. Swift 6에서 Sendable과 SwiftUI의 @Observable 매크로의 긴밀한 통합은 스레드 안전성을 유지하면서 반응성을 가능하게 합니다. 가변 상태를 캡슐화하는 액터부터 상태 캡처를 제한하는 @Sendable 클로저까지, Swift 6가 제공하는 도구는 더 깨끗하고 안전하며 고성능의 동시성을 장려합니다.

저자의 경험에 따르면, 실시간 채팅 애플리케이션을 구축할 때 이러한 기능이 특히 유용했다고 합니다. 액터와 @Sendable 클로저를 사용하여 메시지, 사용자 상태 및 기타 가변 데이터가 서로 다른 비동기 태스크에서 안전하게 처리되도록 보장함으로써 앱의 신뢰성이 크게 향상되었습니다. 또한 레이스 컨디션을 일으킬 수 있는 미묘한 버그를 방지하는 데 도움이 되어 이러한 동시성 도구를 마스터하는 것의 실질적인 이점을 강조했습니다.

개발자와 면접 지원자 모두에게 이러한 동시성 원칙을 마스터하는 것은 현대 Swift에 대한 고급 이해를 보여주며, 이는 높은 수요가 있는 기술 세트를 반영합니다.

[원문: https://medium.com/@wesleymatlock/mastering-sendable-in-swift-6-e13d04d86820](https://medium.com/@wesleymatlock/mastering-sendable-in-swift-6-e13d04d86820)