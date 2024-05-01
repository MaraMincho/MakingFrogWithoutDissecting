//
//  TIL_TodosWithTCASharedApp.swift
//  TIL_TodosWithTCAShared
//
//  Created by MaraMincho on 5/1/24.
//

import SwiftUI

@main
struct TIL_TodosWithTCASharedApp: App {
  var body: some Scene {
    WindowGroup {
      TodosView(store: .init(initialState: Todos.State(), reducer: {
        Todos()
      }))
    }
  }
}
