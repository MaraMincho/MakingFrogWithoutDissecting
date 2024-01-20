//
//  GridStackView.swift
//  MemoryGame
//
//  Created by MaraMincho on 1/18/24.
//

import SwiftUI

struct GridStackView<Content:View>: View {
  let rows: Int
  let columns: Int
  let content: (_ row: Int, _ col: Int) -> Content
  
  var body: some View {
    VStack{
      ForEach(0..<rows, id: \.self) { row in
        HStack{
          ForEach(0..<columns, id: \.self) { col in
            content(row, col)
          }
        }
      }
    }
  }
}

