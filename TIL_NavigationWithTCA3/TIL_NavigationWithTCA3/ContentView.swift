//
//  ContentView.swift
//  TIL_NavigationWithTCA3
//
//  Created by MaraMincho on 6/15/24.
//

import SwiftUI
import ComposableArchitecture

struct FirstReducerNavigationBuilder: Equatable {
  init() {}
  func makeSecondReducerState() -> SecondReducer.State {
    return .init()
  }
}

@Reducer
// 첫번째 뷰 리듀서
struct FirstReducer {
  @ObservableState
  struct State: Equatable {
    var onAppear: Bool = false
    var path: StackState<NavigationDestinationPath.State> = .init([])
    var builder: FirstReducerNavigationBuilder = .init()
  }
  
  @Dependency(\.dismiss) var dismiss
  enum Action: Equatable {
    case navigationSecondScreen
    case navigationThirdScreen
    case onAppear(Bool)
    case path(StackActionOf<NavigationDestinationPath>)
    case push(NavigationDestinationPath.State)
  }
  
  enum CancelID {
    case publisher
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .navigationSecondScreen:
        let state = state.builder.makeSecondReducerState()
        NavigationDestinationPublisher.shared.push(navigationDestination: .second(state))
        return .none
      case .navigationThirdScreen:
        let thirdReducerState = ThirdReducer.State()
        NavigationDestinationPublisher.shared.push(navigationDestination: .third(thirdReducerState))
        return .none
      case .path(_):
        return .none
        
      case .onAppear(_):
        return .publisher {
          NavigationDestinationPublisher.shared.publisher()
            .map{ state in .push(state)}
        }.cancellable(id: CancelID.publisher, cancelInFlight: true)
        
      case let .push(pathState):
        state.path.append(pathState)
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

// 첫번째 뷰
struct FirstView: View {
  @Bindable
  var store: StoreOf<FirstReducer>
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      VStack(spacing: 0) {
        Text("UIHostinhController를 통해 생성된 뷰")
        Button {
          store.send(.navigationSecondScreen)
        } label: {
          Text("Go SecondScreen")
        }
        
        Button {
          store.send(.navigationThirdScreen)
        } label: {
          Text("Go ThirdScreen")
        }
      }
      .onAppear{
        store.send(.onAppear(true))
      }
    } destination: { store in
      switch store.case {
      case let .second(store):
        SecondView(store: store)
      case let .third(store) :
        ThirdView(store: store)
      }
    }
  }
}


@Reducer
struct SecondReducer {
  struct State: Equatable {
    var onAppear: Bool = false
  }
  
  enum Action: Equatable {
    case navigationThirdScreen
  }
  
  var body: some ReducerOf<Self> {
    Reduce { _, action in
      switch action {
      case .navigationThirdScreen:
        return .none
      }
    }
  }
}

struct SecondView: View {
  var store: StoreOf<SecondReducer>
  var body: some View {
    ZStack {
      Color.red.opacity(0.5)
      VStack {
        Button {
          store.send(.navigationThirdScreen)
        } label: {
          Text("Go ThirdScreen")
        }
      }
    }
  }
}


@Reducer
struct ThirdReducer {
  struct State: Equatable {
    var onAppear: Bool = false
  }

  
  enum Action: Equatable {
    case navigationSecondScreen
    
  }
  
  var body: some ReducerOf<Self> {
    Reduce { _, action in
      switch action {
      case .navigationSecondScreen:
        return .none
      
      }
    }
  }
}

struct ThirdView: View {
  var store: StoreOf<ThirdReducer>
  var body: some View {
    ZStack {
      Color.gray.opacity(0.5)
      VStack {
        Button {
          store.send(.navigationSecondScreen)
        } label: {
          Text("Go second")
        }
      }
    }
  }
}
