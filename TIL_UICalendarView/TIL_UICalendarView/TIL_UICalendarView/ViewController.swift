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
    
  }

  private let calendarView: UICalendarView = {
    let calendarView = UICalendarView()
    
    calendarView.translatesAutoresizingMaskIntoConstraints = false
    return calendarView
  }()
  
  func setupViewHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    
    view.addSubview(calendarView)
    calendarView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    calendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    calendarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
  }
}

