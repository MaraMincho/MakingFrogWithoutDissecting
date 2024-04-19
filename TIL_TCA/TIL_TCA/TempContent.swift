//
//  TempContent.swift
//  TIL_TCA
//
//  Created by MaraMincho on 4/18/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct RootViewFeature {
  @Dependency(\.dismiss) var dismiss
  
  @Reducer(state: .equatable)
  enum Path {
    case newScreen(NewScreenFeature)
  }
  
  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
  }
  
  enum Action {
    case NextScreenButtonTapped
    case path(StackAction<Path.State, Path.Action>)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      
      switch action {
      case .NextScreenButtonTapped :
        print(state.path.count)
        state.path.append(.newScreen(NewScreenFeature.State()))
        return .none
      default :
        return .none
      }
    }
    .forEach(\.path, action: \.path)
    
  }
}

struct RootView: View {
  @Bindable var store: StoreOf<RootViewFeature>
  var body: some View {
    
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      VStack {
        Button("NextButton Not Usting NavigationLinke") {
          store.send(.NextScreenButtonTapped)
        }
        NavigationLink(state: RootViewFeature.Path.State.newScreen(NewScreenFeature.State())) {
          Text("asdf")
        }
        Text(store.path.count.description)
      }
    } destination: { store in
      switch store.case {
      case let .newScreen(store):
        NewScreenView(store: store)
      }
    }
  }
}


@Reducer
struct NewScreenFeature {
  @ObservableState
  struct State: Equatable {
    var count = 0
  }
  
  @Dependency(\.dismiss) var dismiss
  
  enum Action {
    case newScreenTapped
    case disMissButtonTapped
  }
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .disMissButtonTapped:
        state.count += 1
        if state.count == 10 {
          return .run { send in
            await self.dismiss()
          }
        }
        return .none
      case .newScreenTapped :
        return .none
      }
    }
  }
}

struct NewScreenView: View {
  @Bindable var store: StoreOf<NewScreenFeature>
  
  var body: some View {
    
    VStack {
      Button(store.state.count.description) {
        store.send(.disMissButtonTapped)
      }
      ForEach(1..<10) { text in
        Text(text.description)
      }
    }
  }
}
