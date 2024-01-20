//
//  CardView.swift
//  MemoryGame
//
//  Created by MaraMincho on 1/18/24.
//

import SwiftUI
import Combine

struct CardView: View {
  let card: Card
  @State var frameIndex = 1
  let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  
  var fileName: String {
    guard let isOpen = card.isOpen else {
      return "f_back"
    }
    return isOpen ?
    String(format: card.prefix + "_%02d_%02d", card.number, frameIndex) :
    "\(card.prefix)_back"
  }
  
  var body: some View {
    Image(fileName)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .onReceive(timer, perform: { _ in
        if card.isOpen != true {
          timer.upstream.connect().cancel()
        }
        frameIndex += 1
        if frameIndex > 8 {
          frameIndex = 1
        }
      })
  }
  
  init(card: Card, frameIndex: Int = 1) {
    self.card = card
    self.frameIndex = frameIndex
  }
}

#Preview {
  CardView(card: .init(number: 3, prefix: "t", isOpen: false), frameIndex: 1)
}
