//
//  ContentView.swift
//  TIL_NavigationWithTCA2
//
//  Created by MaraMincho on 6/14/24.
//

import SwiftUI
import ComposableArchitecture
import UIKit



struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }
}

@Reducer
struct FirstNavigation {
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


final class FirstNavigationViewController: UIHostingController<FirstNavigationView> {
  
}
struct FirstNavigationView: View {
  @Bindable
  var store: StoreOf<FirstNavigation>
  
  var body: some View {
    VStack {
      Button {
//        store.send(.goSecondScreen)
      } label: {
        Text("Go SecondScreen")
      }
      
      Button {
//        store.send(.goThirdScreen)
      } label: {
        Text("Go ThirdScreen")
      }
    }
  }
}
