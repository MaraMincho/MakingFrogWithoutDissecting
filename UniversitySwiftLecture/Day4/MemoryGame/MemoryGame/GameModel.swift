//
//  GameModel.swift
//  MemoryGame
//
//  Created by MaraMincho on 1/18/24.
//

import Foundation

struct Card {
  let number: Int
  
  let prefix: String
  
  /// nil일 경우에는 removed
  var isOpen: Bool?
}

final class GameModel: ObservableObject {
  let rows = 6
  let cols = 3
  
  @Published private var cards: [Card] = []
  @Published private var flipCount: Int = 0
  
  var count: Int { flipCount }
  var openCardIndex: Int? = nil
  let prefix: String
  
  init(prefix: String) {
    self.prefix = prefix
    start()
  }
  
  func card(row: Int, col: Int) -> Card {
    return cards[ row * cols + col ]
  }
  
  func start() {
    flipCount = 0
    let max = cols * rows / 2
    openCardIndex = nil
    cards = (1...max).map{ [Card(number: $0, prefix: prefix, isOpen: false), Card(number: $0, prefix: prefix, isOpen: false)]}.flatMap{$0}
      .shuffled()
  }
  
  func toggle(row: Int, col: Int) {
    let index = row * cols + col
    if index == openCardIndex || cards[index].isOpen == nil {
      return
    }
    if let openCardIndex {
      if cards[openCardIndex].number == cards[index].number {
        flipCount += 1
        cards[index].isOpen = nil
        cards[openCardIndex].isOpen = nil
        self.openCardIndex = nil
        return
      }
      cards[openCardIndex].isOpen = false
    }
    
    flipCount += 1
    cards[ index ].isOpen = true
    
    openCardIndex = index
  }
}
