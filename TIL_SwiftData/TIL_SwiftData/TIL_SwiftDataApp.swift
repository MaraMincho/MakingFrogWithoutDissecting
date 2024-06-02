//
//  TIL_SwiftDataApp.swift
//  TIL_SwiftData
//
//  Created by MaraMincho on 6/2/24.
//

import SwiftUI

@main
struct TIL_SwiftDataApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(for: [Todo.self])
  }
}
