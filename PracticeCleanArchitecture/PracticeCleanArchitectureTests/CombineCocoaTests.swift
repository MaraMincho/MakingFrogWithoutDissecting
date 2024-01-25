//
//  CombineCocoaTests.swift
//
//  Created by MaraMincho on 1/17/24.
//

import Combine
import UIKit
@testable import PracticeCleanArchitecture
import XCTest

final class CombineCocoaTests: XCTestCase {
  var subscriptions = Set<AnyCancellable>()
  override func setUpWithError() throws {
    subscriptions.removeAll()
  }

  override func tearDownWithError() throws {
    subscriptions.removeAll()
  }

  func test_버튼을생성하고_버튼을눌렀을때_Publisher가반응한다() throws {
    let expectation = XCTestExpectation(description: "ButtonPublisherExpectation")

    let button = UIButton()
    button.publisher(.touchUpInside)
      .sink { _ in
        expectation.fulfill()
      }
      .store(in: &subscriptions)

    button.sendActions(for: .allTouchEvents)

    wait(for: [expectation], timeout: 5.0)
  }

  func test_텍스트필드를생성하고_텍스트필드의값을바꾸고_pbulisher가반응한다() throws {
    let expectation = XCTestExpectation(description: "ButtonPublisherExpectation")

    let textField = UITextField()
    textField.publisher(.editingChanged)
      .sink { _ in
        expectation.fulfill()
      }
      .store(in: &subscriptions)

    textField.sendActions(for: .editingChanged)

    wait(for: [expectation], timeout: 5.0)
  }
}
