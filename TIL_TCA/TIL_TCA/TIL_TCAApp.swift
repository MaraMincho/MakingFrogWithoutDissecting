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
  var body: some Scene {
    WindowGroup {
    
      EffectsBasicsView(
        store: Store(initialState: EffectsBasics.State()) {
          EffectsBasics()
            .dependency(\.factClient, FactClient(
              fetch: { number in
                try await Task.sleep(for: .seconds(0))
                let (data, _) = try await URLSession.shared
                  .data(from: URL(string: "http://numbersapi.com/\(number)/trivia")!)
                return "CustomDependencies"
              }
            ))
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
