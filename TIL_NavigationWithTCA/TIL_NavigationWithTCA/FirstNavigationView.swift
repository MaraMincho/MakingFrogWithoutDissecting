//
//  FirstNavigationView.swift
//  TIL_NavigationWithTCA
//
//  Created by MaraMincho on 6/9/24.
//
import ComposableArchitecture
import SwiftUI

@Reducer
struct FirstNavigation {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var path: StackState<Path.State> = .init()
    init() {}
  }
  
  enum Action: Equatable {
    case onAppear(Bool)
    case goSecondScreen
    case goThirdScreen
    case path(StackActionOf<Path>)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      case .goThirdScreen:
        state.path.append(.third(.init()))
        return .none
        
      case .goSecondScreen:
        state.path.append(.second(.init()))
        return .none
        
      case let .path(.element(id: _, action: action)):
        switch action {
        case .second(.goThirdScreen):
          state.path.append(.third(.init()))
          return .none
        case .third(.goSecondScreen):
          state.path.append(.second(.init()))
          return .none
        default:
          return .none
        }
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
  
  @Reducer(state: .equatable, action: .equatable)
  enum Path {
    case second(SecondNavigation)
    case third(ThirdNavigation)
  }
}

struct FirstNavigationView: View {
  // MARK: Reducer
  
  @Bindable
  var store: StoreOf<FirstNavigation>
  
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      VStack(spacing: 0) {
        Button {
          store.send(.goSecondScreen)
        } label: {
          Text("Go SecondScreen")
        }
        
        Button {
          store.send(.goThirdScreen)
        } label: {
          Text("Go ThirdScreen")
        }
      }
      .onAppear {
        store.send(.onAppear(true))
      }
    } destination: { store in
      switch store.case {
      case let .second(store):
        SecondNavigationView(store: store)
      case let .third(store):
        ThirdNavigationView(store: store)
      }
    }
  }
}

@Reducer
struct SecondNavigation {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    init() {}
  }
  
  enum Action: Equatable {
    case onAppear(Bool)
    case goSecondScreen
    case goThirdScreen
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      case .goThirdScreen:
        return .none
      case .goSecondScreen:
        return .none
      }
    }
  }
}

struct SecondNavigationView: View {
  @Bindable
  var store: StoreOf<SecondNavigation>
  var body: some View {
    ZStack {
      Color.red.opacity(0.5)
      VStack {
        Button {
          store.send(.goThirdScreen)
        } label: {
          Text("Go ThirdScreen")
        }
      }
    }
  }
}

@Reducer
struct ThirdNavigation {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    
    init() {}
  }
  
  enum Action: Equatable {
    case onAppear(Bool)
    case goSecondScreen
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      case .goSecondScreen:
        return .none
      }
    }
  }
}

struct ThirdNavigationView: View {
  @Bindable
  var store: StoreOf<ThirdNavigation>
  var body: some View {
    ZStack {
      Color.gray.opacity(0.5)
      
      VStack {
        Button {
          store.send(.goSecondScreen)
        } label: {
          Text("Go SecondsScreen")
        }
      }
    }
  }
}
