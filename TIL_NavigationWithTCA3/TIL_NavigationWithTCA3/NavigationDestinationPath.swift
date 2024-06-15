////
////  NavigationDestinations.swift
////  TIL_NavigationWithTCA3
////
////  Created by MaraMincho on 6/15/24.
////
//
import Combine
import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer(state: .equatable, action: .equatable)
enum NavigationDestinationPath {
  case second(SecondReducer)
  case third(ThirdReducer)
}

final class NavigationDestinationPublisher {
  static let shared = NavigationDestinationPublisher()
  
  private init() {}
  private var _publisher: PassthroughSubject<NavigationDestinationPath.State, Never> = .init()
  
  func publisher() -> AnyPublisher<NavigationDestinationPath.State, Never> {
    return _publisher.eraseToAnyPublisher()
  }
  
  func push(navigationDestination val: NavigationDestinationPath.State) {
    _publisher.send(val)
  }
}
  