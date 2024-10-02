//
//  CoordinatorRouter.swift
//  TCACoordinatorExample
//
//  Created by MaraMincho on 9/2/24.
//

import ComposableArchitecture
import Foundation
import Combine
import SwiftUI

struct CoordinatorRouter {

}

struct PathReducerView<PathReducer: CaseReducer, Content: View, NavigationDestination: View>: View where PathReducer.State: Equatable & ObservableState, PathReducer.Action: Equatable {
  @Bindable var store: StoreOf<RouterReducer<PathReducer>>

  init(
    store: StoreOf<RouterReducer<PathReducer>>,
    @ViewBuilder content: () -> Content,
    navigationDestinationView: @escaping ((StoreOf<PathReducer>) -> NavigationDestination)
  ) {
    self.store = store
    self.content = content()
    self.navigationDestinationView = navigationDestinationView
  }
  var navigationDestinationView: ((StoreOf<PathReducer>) -> NavigationDestination)
  var content: Content
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      content
    } destination: { store in
      navigationDestinationView(store)
    }
  }
}

class RouterReducerRouterPublisher<PathReducer: CaseReducer> {
  init () {}

  private var _pathPublisher: PassthroughSubject<PathReducer.State, Never> = .init()
  var pathPublisher: AnyPublisher<PathReducer.State, Never> {
    _pathPublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }
  func push(_ path: PathReducer.State) {
    _pathPublisher.send(path)
  }

  private var _dismissPublisher: PassthroughSubject<DismissType, Never> = .init()
  var dismissPublisher: AnyPublisher<DismissType, Never>  {
    _dismissPublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }
  func dismiss(_ type: DismissType) {
    _dismissPublisher.send(type)
  }
}

enum DismissType: Equatable {
  case all
  case just
  case multiple(Int)
}

@Reducer
struct RouterReducer<PathReducer: CaseReducer> where PathReducer.State: Equatable & ObservableState, PathReducer.Action: Equatable{

  @ObservableState
  struct State: Equatable {
    var path: StackState<PathReducer.State> = .init()
    @Presents var present: PathReducer.State? = nil
  }
  enum Action: Equatable {
    case path(StackActionOf<PathReducer>)
    case present(PresentationAction<PathReducer.Action>)
  }
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .path:
        return .none
      case .present:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

@Reducer(state: .equatable, action: .equatable)
enum PathDestinationReducer {

}
