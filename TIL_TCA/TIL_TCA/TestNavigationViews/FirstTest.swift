// 
//  FirstTest.swift
//  TIL_TCA
//
//  Created by MaraMincho on 4/24/24.
//
import Foundation
import ComposableArchitecture

@Reducer
struct FirstTest {

  @ObservableState
  struct State: Equatable {
    var path: StackState<NavigationRoot.NavigationRootPath.State>
    var isOnAppear = false
  }

  indirect enum Action: Equatable {
    case onAppear(Bool)
    case path(StackAction<NavigationRoot.NavigationRootPath.State, NavigationRoot.NavigationRootPath.Action>)
    case tappedButton
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .tappedButton:
        state.path.append(.secondTest(.init()))
        print("tapped buttoned")
        print(state.path.count)
        
        return .none
      case let .onAppear(isAppear) :
        state.isOnAppear = isAppear
        return .none
      default:
        return .none
      }
    }
  }
}
