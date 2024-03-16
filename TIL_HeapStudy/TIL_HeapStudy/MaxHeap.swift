//
//  MaxHeap.swift
//  TIL_HeapStudy
//
//  Created by MaraMincho on 3/16/24.
//

import Foundation

struct MaxHeap<T> where T: Comparable {
  var count: Int { elements.count - 1}
  var peak: T? { elements.indices.contains(1) ? elements[1] : nil }
  var isEmpty: Bool { !elements.indices.contains(1) }
  var elements: [T] = []
  
  mutating func append(_ element: T) {
    if isEmpty {
      elements.append(element)
    }
    elements.append(element)
    push(count)
  }
  
  private mutating func push(_ ind: Int) {
    let pInd = ind / 2
    if pInd == 0 {
      return
    }
    if elements[pInd] < elements[ind] {
      elements.swapAt(pInd, ind)
      push(pInd)
    }
  }
  
  mutating func delete() -> T? {
    guard elements.indices.contains(1) else {
      return nil
    }
    
    let ind = count
    elements.swapAt(ind, 1)
    let deleteVal = elements.popLast()
    shift(1)
    
    return deleteVal
  }
  
  private mutating func shift(_ ind: Int) {
    let leftInd = ind * 2
    let rightInd = ind * 2 - 1
    var targetInd = ind
    
    if elements.indices.contains(leftInd) && elements[leftInd] > elements[targetInd] {
      targetInd = leftInd
    }
    
    if elements.indices.contains(rightInd) && elements[rightInd] > elements[targetInd] {
      targetInd = rightInd
    }
    
    if targetInd != ind {
      elements.swapAt(ind, targetInd)
      shift(targetInd)
    }
  }
  
}
