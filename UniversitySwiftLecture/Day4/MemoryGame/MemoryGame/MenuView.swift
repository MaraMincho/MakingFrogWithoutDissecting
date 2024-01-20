//
//  MenuView.swift
//  MemoryGame
//
//  Created by MaraMincho on 1/18/24.
//

import SwiftUI

struct MenuView: View {
  var prefixes = ["f", "t"]
    var body: some View {
      NavigationView{
        List{
          ForEach(prefixes, id: \.self) { prefix in
            MenuItemView(prefix: prefix)
          }
        }
      }
    }
}

struct MenuItemView: View {
  var prefix: String
  var body: some View {
    
    HStack {
      Image("\(prefix)_back")
    }
    NavigationLink{
      GameView(prefix: prefix)
    } label: {
      Text("Game \(prefix)")
    }
  }
}

#Preview {
    MenuView()
}
