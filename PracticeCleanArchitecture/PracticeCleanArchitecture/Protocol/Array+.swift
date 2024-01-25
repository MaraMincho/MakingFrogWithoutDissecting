//
//  Array+.swift

//
//  Created by MaraMincho on 1/16/24.
//

import Foundation

/// https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings
extension Collection {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
