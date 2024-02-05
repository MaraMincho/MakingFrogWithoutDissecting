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
    singleSelectDate.setSelected(.init(calendar: .init(identifier: .gregorian), year: 2024, month: 2, day: 5), animated: true)
  }

  var decorations: [Date?: DateDecorationType] = [:]
  
  func addValentinesDay() {
    let valentinesDay = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2024, month: 2, day: 14)
    // Create a calendar decoration for Valentine's day.
    decorations = [valentinesDay.date: .heart]
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
}

enum DateDecorationType {
  case heart
}

extension ViewController: UICalendarViewDelegate {
  func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
    let day = DateComponents(calendar: dateComponents.calendar, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day)
    return makeDecoration(by: decorations[day.date])
  }
  
  func makeDecoration(by type: DateDecorationType?) -> UICalendarView.Decoration? {
    guard let type else { return nil }
    switch type {
    case .heart:
      return UICalendarView.Decoration.image(UIImage(systemName: "heart.fill"), color: UIColor.red, size: .large)
    }
  }
}


extension ViewController: UICalendarSelectionSingleDateDelegate {
  func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
    guard let dateComponents else { return }
    print("\(dateComponents.year!)년 \(dateComponents.month!)월 \(dateComponents.day!)일")
  }
}
var decorations: [Date?: UICalendarView.Decoration] = [:]

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

class TestViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setup()
  }
  
  func setup() {
    addValentinesDay()
    setupViewHierarchyAndConstraints()
  }
  private lazy var calendarView: UICalendarView = {
    let calendarView = UICalendarView()
    calendarView.delegate = self
    
    calendarView.translatesAutoresizingMaskIntoConstraints = false
    return calendarView
  }()
  
  func addValentinesDay() {
    let valentinesDay = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2024, month: 2, day: 14)
    // Create a calendar decoration for Valentine's day.
    let decoration = UICalendarView.Decoration.image(UIImage(systemName: "heart.fill"), color: UIColor.red, size: .large)
    decorations = [valentinesDay.date: decoration]
  }
  
  func setupViewHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    
    view.addSubview(calendarView)
    calendarView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    calendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    calendarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
  }
}

extension TestViewController: UICalendarViewDelegate {
  func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
    let day = DateComponents(calendar: dateComponents.calendar, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day)
    return decorations[day.date]
  }
}
