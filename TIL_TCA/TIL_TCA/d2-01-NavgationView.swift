////
////  d2-01-NavgationView.swift
////  TIL_TCA
////
////  Created by MaraMincho on 4/21/24.
////
//
//import SwiftUI
//import ComposableArchitecture
//
//@Reducer
//struct First {
//  @ObservableState
//  struct State {
//    var path = StackState<Path.State>()
//  }
//  @Reducer(state: .equatable)
//  enum Path {
//    case second(Second)
//    case third(Third)
//  }
//  
//  enum Action {
//    case tappedNextButton
//    case pathAction(StackAction<Path.State, Path.Action>)
//  }
//  
//  var body: some Reducer<State, Action> {
//    Reduce { state, action in
//      return .none
//    }
//  }
//}
//
//struct FirstView: View {
//  var store: StoreOf<First>
//  var body: some View {
//    NavigationStackStore(store.scope(state: \.path, action: {.pathAction($0)})) {
//      
//      VStack {
//        
//
//      }
//      
//    } destination: { state in
//      switch state {
//      case .
//      }
//    }
//
//  }
//}
//
//
//@Reducer
//struct Second {
//  @ObservableState
//  struct State {
//    var path = StackState<Path.State>()
//  }
//  @Reducer(state: .equatable)
//  enum Path {
//    
//  }
//  
//  enum Action {
//    case tappedNextButton
//    case pathAction(StackAction<Path.State, Path.Action>)
//  }
//  
//  var body: some Reducer<State, Action> {
//    Reduce { state, action in
//      return .none
//    }
//  }
//}
//struct SecondView: View {
//  var store: StoreOf<First>
//  var body: some View {
//    NavigationStackStore(store.scope(state: \.path, action: {.pathAction($0)})) {
//      VStack {
//        
//
//      }
//      
//    } destination: { store in
//      
//    }
//
//  }
//}
//
//@Reducer
//struct Third {
//  @ObservableState
//  struct State {
//    var path = StackState<Path.State>()
//  }
//  @Reducer(state: .equatable)
//  enum Path {
//    
//  }
//  
//  enum Action {
//    case tappedNextButton
//    case pathAction(StackAction<Path.State, Path.Action>)
//  }
//  
//  var body: some Reducer<State, Action> {
//    Reduce { state, action in
//      return .none
//    }
//  }
//}
//
//struct ThirdView: View {
//  var store: StoreOf<First>
//  var body: some View {
//    NavigationStackStore(store.scope(state: \.path, action: {.pathAction($0)})) {
//      VStack {
//        
//
//      }
//      
//    } destination: { store in
//      
//    }
//
//  }
//}
