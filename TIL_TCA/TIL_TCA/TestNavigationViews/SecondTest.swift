// 
//  SecondTest.swift
//  TIL_TCA
//
//  Created by MaraMincho on 4/24/24.
//
import Foundation
import ComposableArchitecture

@Reducer
struct SecondTest {

  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
  }

  enum Action: Equatable {
    case onAppear(Bool)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear) :
        state.isOnAppear = isAppear
        return .none
      default:
        return .none
      }
    }
  }
}
