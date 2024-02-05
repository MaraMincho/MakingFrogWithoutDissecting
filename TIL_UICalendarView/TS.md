# UICalendarView TroubleShotting

# Month를 왔다갔다 하면 앱이 비정상적으로 종료되는 현상

분명 Decordation을 위해서 공식문서의 코드를 기재하였습니다. Decoration이라는 `var decorations: [Date?: UICalendarView.Decoration] = [:]` 변수에 정확하게 Decoration을 넣었지만 계속한 error가 발생했습니다.

에러 메시지는 다음과 같습니다.

Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[__NSArrayM insertObject:atIndex:]: object cannot be nil'


<video>
 <source src = "https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/0d3ea14d-f275-4b1d-b6c8-d8efda347829" type = "video.mp4">
</video>

<br/><br/>

# 몇가지 실험

### Dictonary Type을 Date: UICalendarView.Decoration 로 변경해보자.
어쩄거자 저쨌거나 object가 nil이니까 nil위험이 있는 항목에 대해서 실험을 해봤습니다.

```swift
extension ViewController: UICalendarViewDelegate {
  func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
    let day = DateComponents(calendar: dateComponents.calendar, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day)
    guard let date = day.date else {
      return nil
    }
    return decorations[date]
  }
}
```

실패했습니다. 여전히 nil에러가 발생하네요.

<br/><br/>

### Dictionary value의 문제
Dictionary에 저장하는 것은 참조로, 달력을 왔다갔다 하면서 참조 값이 사라질 수 있다고 생각했습니다. 이건 내부적으로 어떻게 동작하는지 모르지만, 가능성에 대해서 생각해봤습니다. 

```swift
var decorations: [Date?: DateDecorationType] = [:]

/// ...

func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
    let day = DateComponents(calendar: dateComponents.calendar, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day)
    return makeDecoration(by: decorations[day.date])
  }

/// ...

func makeDecoration(by type: DateDecorationType?) -> UICalendarView.Decoration? {
    guard let type else { return nil }
    switch type {
    case .heart:
      return UICalendarView.Decoration.image(UIImage(systemName: "heart.fill"), color: UIColor.red, size: .large)
    }
}

```

성공했습니다. object에 Nil이 발생하지 않네요. Decoration에 object nil 에러가 발생하지 않습니다. 

<br/><br/>

### 버그가 생긴 이유에 대해서
이건 개인적인 생각인데 CalendarView를 CollectionView로 이용해서 만든 것 같습니다. Reusable Cell을 설정하는 과정에서 버그가 터졌다고 생각합니다. 애플 공식문서에 관해서 메일 보냈습니다. 
답변 받으면 추가 내용 작성하겠습니다.

![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/bcd45be6-beef-45c3-829a-dd87d4524cdc)
