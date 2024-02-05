//
//  ViewController.swift
//  TIL_UICalendarView
//
//  Created by MaraMincho on 2/5/24.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupViewHierarchyAndConstraints()
    restrictDate()
    addValentinesDay()
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
      self.addTodayIsNoLeftOverFood()
    }
    singleSelectDate.setSelected(.init(calendar: .init(identifier: .gregorian), year: 2024, month: 2, day: 5), animated: true)
  }

  var decorations: [Date: UICalendarView.Decoration] = [:]
  
  func addValentinesDay() {
    let valentinesDay = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2024, month: 2, day: 14)
    // Create a calendar decoration for Valentine's day.
    let heart = UICalendarView.Decoration.image(UIImage(systemName: "heart.fill"), color: UIColor.red, size: .large)
    guard let date = valentinesDay.date else {
      return
    }
    decorations = [date: heart]
  }
  
  
  private lazy var singleSelectDate = UICalendarSelectionSingleDate(delegate: self)
  private lazy var multipleSelectionDate = UICalendarSelectionMultiDate(delegate: self)
  
  private lazy var calendarView: UICalendarView = {
    let calendarView = UICalendarView()
    calendarView.delegate = self
    calendarView.selectionBehavior = multipleSelectionDate
    
    calendarView.translatesAutoresizingMaskIntoConstraints = false
    return calendarView
  }()
  
  func restrictDate() {
    let gregorianCalendar = Calendar(identifier: .gregorian)
    let fromDateComponents = DateComponents(calendar: gregorianCalendar, year: 2024, month: 1, day: 1)
    let toDateComponents = DateComponents(calendar: gregorianCalendar, year: 2024, month: 3, day: 1)

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
  
  func setupViewHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    
    view.addSubview(calendarView)
    calendarView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    calendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    calendarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
  }
  
  func addTodayIsNoLeftOverFood() {
    let decoration: UICalendarView.Decoration = .customView {
      let label = UILabel()
      label.text = "🍚"
      return label
    }
    add(decoration: decoration, on: .now)
  }
  // Add a decoration to the specified date.
  func add(decoration: UICalendarView.Decoration, on date: Date) {
    let dateComponents = Calendar.current.dateComponents(
      [.calendar, .year, .month, .day ],
      from: date
    )
    // Add the decoration to the decorations dictionary.
    guard let date = dateComponents.date else { return }
    decorations[date] = decoration
    // Reload the calendar view's decorations.
    calendarView.reloadDecorations(
      forDateComponents: [dateComponents],
      animated: true
    )
  }
}

extension ViewController: UICalendarViewDelegate {
  func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
    let day = DateComponents(calendar: dateComponents.calendar, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day)
    guard let date = day.date else {
      return nil
    }
    return decorations[date]
  }
}


extension ViewController: UICalendarSelectionSingleDateDelegate {
  func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
    guard let dateComponents else { return }
    print("\(dateComponents.year!)년 \(dateComponents.month!)월 \(dateComponents.day!)일")
  }
}

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
