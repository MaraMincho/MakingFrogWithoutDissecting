
# Today I Learned UICalendarView

# [UICalendarview 란 무엇일까?](https://developer.apple.com/documentation/uikit/uicalendarview#3992449)

날짜별 장식이 있는 일정관리를 표시하고, 단일 날짜 또는 여러 날짜를 사용자가 선택할 수 있도록 제공하는 보기입니다.

A view that displays a calendar with date-specific decorations, and provides for user selection of a single date or multiple dates.

### Overview

일정관리 보기를 사용하여 사용자가 사용자 정의한 장식을 사용하여 추가 정보(예: 예약된 이벤트)가 있는 특정 날짜를 표시할 수 있습니다. 또한 일정관리 보기를 사용하여 하나의 특정 날짜, 여러 날짜 또는 날짜가 없는 날짜를 선택할 수 있습니다.
인터페이스에 일정관리 보기를 추가하려면:

- 일정관리 보기가 표시되도록 일정관리 및 로케일을 구성합니다.
- 일정관리 보기를 처음에 표시할 날짜를 설정합니다.
- 원하는 경우 특정 날짜에 장식을 제공할 대리인을 작성합니다.
- 날짜 선택을 처리할 선택 방법 및 위임자를 설정합니다.
- Auto Layout(자동 레이아웃)을 설정하여 인터페이스에 일정관리 보기를 배치합니다.
- 달력 보기는 날짜 표시 및 선택에만 사용합니다. 날짜 및 시간 선택을 처리하려면 UIDatePicker를 사용합니다.

Use a calendar view to show users specific dates that have additional information (for example, scheduled events) using decorations that you customize. You can also use a calendar view for users to select one specific date, multiple dates, or no date.
To add a calendar view to your interface:

- Configure the Calendar and Locale for your calendar view to display.
- Set a date for the calendar view to initially make visible.
- Create a delegate to provide decorations on specific dates, if desired.
- Set a selection method and delegate to handle date selection.
- Set up Auto Layout to position the calendar view in your interface.
- You use a calendar view only for the display and selection of dates. If you want to handle date and time selection, use UIDatePicker.


### 실제 코드 작동 모습

```swift
private let calendarView: UICalendarView = {
let calendarView = UICalendarView()

calendarView.translatesAutoresizingMaskIntoConstraints = false
return calendarView
}()

```
<br/>
<img src = "https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/35b45bc5-c298-4a38-a518-1fb2be5bd43c" width = 250>


# Configure a calendar view

## 달력 기본 세팅 조정

유저 위치나, 문화적 선호에 맞는 캘린더를 만들 수 있습니다. 기본적으로 캘린더뷰는 유저의 현재 [캘린더](Configure a calendar view)와 위치를 선택합니다. 다음과 같이 다른 캘린더나 지역을 선택하게 할 수 있습니다.

```swift
// Create the calendar view.
let calendarView = UICalendarView()


// Create an instance of the Gregorian calendar.
let gregorianCalendar = Calendar(identifier: .gregorian)


// Set the calendar displayed by the view.
calendarView.calendar = gregorianCalendar


// Set the calendar view's locale.
calendarView.locale = Locale(identifier: "zh_TW")


// Set the font design to the rounded system font.
calendarView.fontDesign = .rounded

```

<br/><br/>

### 실제 적용 모습
`calendarView.calendar = .init(identifier: .japanese)`

<img src = "https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/77f117a6-52b6-406d-89ee-2bf12cd06259" width = 300>


캘린더뷰의 시작 날짜를 보이게 하기 위해서 DateComponents를 조정할 수 있습니다.

```swift
// Set the date to display.
calendarView.visibleDateComponents = DateComponents(
    calendar: gregorianCalendar,
    year: 2024,
    month: 2,
    day: 1
)
```

<br/><br/>

## 날짜 제한

만약 시작날짜와 종료날짜(보여줄)를 제한하고 싶다면 [availableDateRange](https://developer.apple.com/documentation/uikit/uicalendarview/3987955-availabledaterange) 를 설정하면 됩니다.

### 실제 적용 모습
2024 2월 2일부터 2월 10일까지 Range로 설정 했습니다. 범위에 포함되지 않은 날짜들은 회색으로 표시되고 가능한 날짜는 검정색으로 볼 수 있습니다. 
</br>
```swift
func restrictDate() {
    let gregorianCalendar = Calendar(identifier: .gregorian)
    let fromDateComponents = DateComponents(calendar: gregorianCalendar, year: 2024, month: 2, day: 2)
    let toDateComponents = DateComponents(calendar: gregorianCalendar, year: 2024, month: 2, day: 10)

    // Verify that you have valid start and end dates.
    guard 
      let fromDate = fromDateComponents.date,
      let toDate = toDateComponents.date else {
        // Handle the error here.
        fatalError("Invalid date components: \(fromDateComponents) and \(toDateComponents)")
    }
    // Set the range of dates that people can view.
    let calendarViewDateRange = DateInterval(start: fromDate, end: toDate)
    calendarView.availableDateRange = calendarViewDateRange
}
```

<img src = "https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/883bcb85-7594-4b2c-b5d2-1521e5e9da21" width = 300 >


# 특정한 날짜에 데코레이션을 보여주기

데코레이션을 활용하면 유저에게 특정한 날짜에 추가적인 정보가 있다는 것을 보여줄 수 있습니다. 데코레이션을 보여주려면, UICalendarViewDelegate objet을 구현하고,  calendarView(_:decorationFor:)을 만들면 됩니다. 

```swift

func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
    let day = DateComponents(calendar: dateComponents.calendar, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day)
    // Return any decoration saved for that date.
    return decorations[day.date]
  }
```

<img src = "https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/013d7df7-db03-4167-a99d-899c07097fdd" width = 300>


구현 시 사용자의 이벤트를 가장 잘 보여주는 UICalendarView.Decoration 유형을 결정할 수 있습니다:
- 색상 및 상대 크기로 사용자 정의할 수 있는 채워진 원을 표시하는 기본 장식
- 시스템 기호 또는 이미지, 색상 및 상대 크기로 사용자 지정할 수 있는 이미지 장식
- 사용자 정의 보기를 반환하는 닫기로 사용자 정의할 수 있는 사용자 정의 장식
  
데이터가 변경되면 달력 보기에 장식 보기를 다시 로드하라고 말합니다.

```swift

// Add a decoration to the specified date.
func add(decoration: UICalendarView.Decoration, on date: Date) {
    // Get the calendar, year, month, and day date components for
    // the specified date.
    let dateComponents = Calendar.current.dateComponents(
        [.calendar, .year, .month, .day ],
        from: date
    )
    
    // Add the decoration to the decorations dictionary.
    decorations[dateComponents.date] = decoration
    
    // Reload the calendar view's decorations.
    if let calendarView {
        calendarView.reloadDecorations(
            forDateComponents: [dateComponents],
            animated: true
        )
    }
}
```

### 실제 적용 모습

```swift
DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    self.addTodayIsNoLeftOverFood()
}
      
func addTodayIsNoLeftOverFood() {
    let decoration: UICalendarView.Decoration = .customView {
      let label = UILabel()
      label.text = "🍚"
      return label
    }
    add(decoration: decoration, on: .now)
  }
```

<img src="https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/62bdcbbf-5570-41c1-905f-5150a3306a81" width = 300>

<br/><br/>

# 데이트 섹션 Handle

유저가 하루의 날짜 혹은 여러 날을 선택하기 위해서는 첫째로 어떤 타입으로 선택할 것인지 먼저 정의해야 합니다. 그다음 selection object와 `Delegate`을 만들어야 합니다. 그 다음 `calendarView`의 `selectionBehavior`을 assign해야 합니다.

```swift

let dateSelection = UICalendarSelectionSingleDate(delegate: self)
calendarView.selectionBehavior = dateSelection

```

<br/><br/>

### 실제 적용 모습

```swift

let singleSelectDate = UICalendarSelectionSingleDate(delegate: self)

calendarView.selectionBehavior = singleSelectDate


// ... 
singleSelectDate.setSelected(.init(calendar: .init(identifier: .gregorian), year: 2024, month: 2, day: 5), animated: true)

// ... 

extension ViewController: UICalendarSelectionSingleDateDelegate {
  func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
    guard let dateComponents else { return }
    print("\(dateComponents.year!)년 \(dateComponents.month!)월 \(dateComponents.day!)일")
  }
}
```

|캘린더|콘솔창|
|:-:|:-:|
|<img src="https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/eedf02a4-89a1-4002-a76b-96d7df58f88d">|![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/41fe0f18-21b1-40bb-ae2d-f613609da78e)|

<br/><br/>

### 멀티플 설렉트
```swift
extension ViewController: UICalendarSelectionMultiDateDelegate {
  func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
    print("선택 되었습니다.")
    print(dateComponents)
  }
  
  func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
    print("선택을 취소했습니다.")
    print(dateComponents)
  }
}
```

|캘런더|콘솔창|
|:-:|:-:|
|<img src="https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/68ebbd37-25a1-40c1-8936-feb5a7b8fbb7" width = 300 >|<img src="https://private-user-images.githubusercontent.com/103064352/302164832-1c39c2bd-59ea-4094-bdfd-eaf049a53351.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDcxMDI4NzksIm5iZiI6MTcwNzEwMjU3OSwicGF0aCI6Ii8xMDMwNjQzNTIvMzAyMTY0ODMyLTFjMzljMmJkLTU5ZWEtNDA5NC1iZGZkLWVhZjA0OWE1MzM1MS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMjA1JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDIwNVQwMzA5MzlaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT05MmM4ZWUwMjEzNjZiNmE0MDZhYjcwNmI4N2MxOGNlOWZhODcxYTU2ODJjMWQyNDg4MTI4YWRjNTEzNDE3ODZhJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.8V5Z1PL5pvzoyAzOwG3Ba58AKfLd8B7NOZW0y6MgP7k">|
