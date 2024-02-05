# UICalendarView TroubleShotting

# Month를 왔다갔다 하면 앱이 비정상적으로 종료되는 현상

분명 Decordation을 위해서 공식문서의 코드를 기재하였습니다. Decoration이라는 `var decorations: [Date?: UICalendarView.Decoration] = [:]` 변수에 정확하게 Decoration을 넣었지만 계속한 error가 발생했습니다.

에러 메시지는 다음과 같습니다.

Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[__NSArrayM insertObject:atIndex:]: object cannot be nil'


<video src = "https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/0d3ea14d-f275-4b1d-b6c8-d8efda347829">

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