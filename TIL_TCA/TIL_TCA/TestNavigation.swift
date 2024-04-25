//
//  TestNavigation.swift
//  TIL_TCA
//
//  Created by MaraMincho on 4/24/24.
//

import SwiftUI
import ComposableArchitecture

extension NavigationRoot {
  @Reducer
  struct NavigationRootPath {
    @ObservableState
    enum State: Equatable {
      case firstText(FirstTest.State)
      case bindingForm(BindingForm.State = .init())
      case secondTest(SecondTest.State)
    }
    
    enum Action: Equatable {
      case bindingForm(BindingForm.Action)
      case firstText(FirstTest.Action)
      case secondTest(SecondTest.Action)
    }
    
    var body: some Reducer<State, Action> {
      Scope(state: \.firstText, action: \.firstText) {
        FirstTest()
      }
      Scope(state: \.bindingForm, action: \.bindingForm) {
        BindingForm()
      }
      Scope(state: \.secondTest, action: \.secondTest) {
        SecondTest()
      }
    }
  }
}


@Reducer
struct NavigationRoot {
  
  @ObservableState
  struct State: Equatable {
    var nextPath = StackState<NavigationRootPath.State>()
  }
  
  enum Action {
    case nextPath(StackAction<NavigationRootPath.State, NavigationRootPath.Action>)
    case tapped
  }
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .tapped:
        state.nextPath.append(.bindingForm(BindingForm.State()))
      case let .nextPath(action) :
        switch action {
        case .element(id: _, action: .bindingForm(.resetButtonTapped)) :
          state.nextPath.append(.firstText(FirstTest.State(path: state.nextPath)))
          return .none
//        case .element(id: _, action: .bindingForm())
        default:
          break
        }
      }
      return .none
    }
    .forEach(\.nextPath, action: \.nextPath) {
      NavigationRootPath()
    }
  }
}

struct NavigationRootView: View {
  @Bindable
  var store: StoreOf<NavigationRoot>
  var body: some View {
    
//    VStack {
//      NavigationStack {
//        
//      }
//    }
    VStack {
      NavigationStack(path: $store.scope(state: \.nextPath, action: \.nextPath)) {
        Button("push man") {
          store.send(.tapped)
        }
      } destination: { store in
        switch store.state {
        case .secondTest:
          if let store = store.scope(state: \.secondTest, action: \.secondTest) {
            SecondTestView(store: store)
          }
        case .firstText:
          if let store = store.scope(state: \.firstText, action: \.firstText) {
            FirstTestView(store: store)
          }
        case .bindingForm:
          if let store = store.scope(state: \.bindingForm, action: \.bindingForm) {
            BindingFormView(store: store)
          }
        }
      }
      
    }
    
    
  }
}
