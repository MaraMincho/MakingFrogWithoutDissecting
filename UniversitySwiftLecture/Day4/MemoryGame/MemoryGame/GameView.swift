//
//  ContentView.swift
//  MemoryGame
//
//  Created by MaraMincho on 1/18/24.
//

import SwiftUI

struct GameView: View {
  let prefix: String
  @ObservedObject var model: GameModel
  @State var showsRetryAlert = false
  
  init(prefix: String) {
    self.prefix = prefix
    self.model = .init(prefix: prefix)
  }
  var body: some View {
    VStack {
      HStack{
        Text("메모리 게임")
          .font(.largeTitle)
        Spacer()
        Text("몇번?: \(model.count)")
      }
      GridStackView(rows: model.rows, columns: model.cols) { row, col in
        CardView(card: model.card(row: row, col: col))
          .onTapGesture {
            model.toggle(row: row, col: col)
          }
      }
      Button{
        
      }label: {
        Text("뒤로 가기")
      }
      Button{
        showsRetryAlert = !showsRetryAlert
      }label: {
        Text("Restart")
          .font(.title)
          .padding()
          .background(
            Capsule()
              .stroke(lineWidth: 3)
          )
          .shadow(color: .gray, radius: 10, x: 3, y: 3)
      }
    }
    .padding()
    .background(
      LinearGradient(colors: [.white, .blue.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
    )
    .alert(isPresented: $showsRetryAlert, content: {
      Alert(
        title: Text("정말로 종료하시겠습까?"),
        message: Text("종료 하시면 되돌릴 수 없습니다."),
        primaryButton: .cancel(),
        secondaryButton: .destructive(Text("종료"), action: {
          model.start()
        }))
    })
    .toolbar(.hidden)
  }
}
