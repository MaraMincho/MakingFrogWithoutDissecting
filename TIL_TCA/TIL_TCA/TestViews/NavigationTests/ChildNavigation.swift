// 
//  ChildNavigation.swift
//  TIL_TCA
//
//  Created by MaraMincho on 7/31/24.
//
import Foundation
import ComposableArchitecture


@Reducer
enum ChildPath {
  case d1(AlertAndConfirmationDialog)
  case d2(Counter)
}
@Reducer
struct ChildNavigation {

  @ObservableState
  struct State {
    var isOnAppear = false
    var path: StackState<ChildPath.State> = .init()
    init () {}
  }

  enum Action {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedButton(Int)
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction {
    case path(StackActionOf<ChildPath>)
  }

  enum DelegateAction: Equatable {}

  var viewAction: (_ state: inout State, _ action: ViewAction) -> Effect<Action> = { state, action in
    switch action {
    case let .onAppear(isAppear) :
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .none
    case let .tappedButton(val):
      if val % 2 == 0 {
        state.path.append(.d1(.init()))
      }else {
        state.path.append(.d2(.init()))
      }
      return .none
    }
  }

  var scopeAction: (_ state: inout State, _ action: ScopeAction) -> Effect<Action> = { state, action in
    return .none
  }

  var innerAction: (_ state: inout State, _ action: InnerAction) -> Effect<Action> = { state, action in
    return .none
  }

  var asyncAction: (_ state: inout State, _ action: AsyncAction) -> Effect<Action> = { state, action in
    return .none
  }

  var delegateAction: (_ state: inout State, _ action: DelegateAction) -> Effect<Action> = { state, action in
    return .none
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      case let .scope(currentAction) :
        return scopeAction(&state, currentAction)
      case let .delegate(currentAction) :
        return delegateAction(&state, currentAction)
      }
    }
    .forEach(\.path, action: \.scope.path)
  }
}

extension Reducer where Self.State == ChildNavigation.State, Self.Action == ChildNavigation.Action { }
