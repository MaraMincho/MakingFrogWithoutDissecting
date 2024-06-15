//
//  TIL_NavigationWithTCA3App.swift
//  TIL_NavigationWithTCA3
//
//  Created by MaraMincho on 6/15/24.
//

import SwiftUI

@main
struct TIL_NavigationWithTCA3App: App {
  var body: some Scene {
    WindowGroup {
      FirstView(store: .init(initialState: FirstReducer.State(), reducer: {
        FirstReducer()
      }))
    }
  }
}
