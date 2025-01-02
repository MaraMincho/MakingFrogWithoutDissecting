//
//  RecapMainController.swift
//  SLRecap
//
//  Created by MaraMincho on 12/31/24.
//  Copyright © 2024 com.swimlight. All rights reserved.
//

import Combine
import Foundation

// MARK: - RecapMainController

@Observable
public final class RecapMainController {
  private var _currentPage: Int = 0
  var currentPage: Int { _currentPage }

  private let pageRemainSeconds: Double
  private let tickWeight: Double
  private var _currentDurationPercentage: Double = 0
  var currentDurationPercentage: Double { _currentDurationPercentage / 100 }

  private var subscriptions = Set<AnyCancellable>()
  let dismissPublisher: PassthroughSubject<Void, Never> = .init()

  private var _pageCount: Int = 1
  var pageCount: Int { _pageCount }

  public init(pageRemainSeconds: Int = 10) {
    self.pageRemainSeconds = Double(pageRemainSeconds)
    tickWeight = 100.0 / Double(pageRemainSeconds) / 10.0
    configure()
  }

  func updatePageCount(_ newPageCount: Int) {
    _pageCount = newPageCount
  }

  func goNextPage() {
    _currentDurationPercentage = 0
    if _currentPage + 1 >= pageCount {
      dismissPublisher.send()
      return
    }
    _currentPage += 1
  }

  func goPrevPage() {
    _currentPage = max(_currentPage - 1, 0)
    _currentDurationPercentage = 0
  }

  func configure() {
    Timer.publish(every: 0.1, tolerance: .infinity, on: .main, in: .default)
      .autoconnect()
      .sink { [weak self] _ in
        guard let self else { return }
        tickStream()
      }
      .store(in: &subscriptions)
  }

  private func tickStream() {
    _currentDurationPercentage += tickWeight
    if _currentDurationPercentage >= 100 {
      goNextPage()
    }
  }
}
