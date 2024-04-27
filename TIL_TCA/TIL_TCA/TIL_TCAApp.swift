//
//  TIL_TCAApp.swift
//  TIL_TCA
//
//  Created by MaraMincho on 4/14/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct TIL_TCAApp: App {
  @ObservedObject
  var router = Router.shared
  var body: some Scene {
    WindowGroup {
    
      SharedStateView(
        store: Store(initialState: SharedState.State()) {
          SharedState()
        }
      )
      
    }
  }
}


func foo(initialClosure: () -> (), sar: Int) {
  print("before")
  initialClosure()
  print("after")
}
func bar(initialClosure: @autoclosure () -> (), sar: Int) {
  print("before")
  initialClosure()
  print("after")
}

//func maybeMain() {
//  // Error
//  foo(initialClosure: print("Im not auto closure"), sar: 0)
//  // OK
//  foo(initialClosure: {print("Im not auto closure")}, sar: 1)
//  // OK
//  foo(initialClosure: { print("Im not auto closure") }, sar: 2)
//  
//  // UsingAutoClosure
//  bar(initialClosure: print("Im auto closure"), sar: 3)
//}
//
//func makeStore() {
//  CounterDemoView(store:
//      .init(initialState: {
//        Counter.State()
//      }(), reducer: {
//        Counter()
//      })
//  )
//}
