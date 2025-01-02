//
//  ContentView.swift
//  RecapExample
//
//  Created by MaraMincho on 1/2/25.
//

import SwiftUI

struct ContentView: View {
  @State
  var controller = RecapMainController(pageRemainSeconds: 5)
  var body: some View {
    RecapMainView(controller: controller) {
      VStack {
        Image(systemName: "globe")
          .imageScale(.large)
          .foregroundStyle(.tint)
        Text("Hello, page 1 world!")
      }
      .background(Color.red)
      .padding()

      VStack {
        Image(systemName: "star")
          .imageScale(.large)
          .foregroundStyle(.tint)
        Text("hi, page 2 land!")
      }
      .background(Color.white)
      .padding()

      VStack {
        Image(systemName: "person.fill")
          .imageScale(.large)
          .foregroundStyle(.tint)
        Text("nihao, page 3 world!")
      }
      .background(Color.cyan)
      .padding()
    }
    .background(Color.blue)
  }
}

#Preview {
    ContentView()
}
