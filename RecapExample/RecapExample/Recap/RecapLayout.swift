//
//  RecapLayout.swift
//  SLRecap
//
//  Created by MaraMincho on 12/30/24.
//  Copyright © 2024 com.swimlight. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - RecapLayout

public struct RecapLayout: Layout {
  private var pageCount: Int = 1
  private var currentPageCount: (Int) -> Void

  public init(currentPageCount: @escaping (Int) -> Void) {
    self.currentPageCount = currentPageCount
  }

  public func sizeThatFits(proposal: ProposedViewSize, subviews _: Subviews, cache _: inout ()) -> CGSize {
    CGSize(width: proposal.width ?? 0, height: proposal.height ?? 0)
  }

  public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
    currentPageCount(subviews.count)
    let pageWidth = bounds.width

    for (index, subview) in subviews.enumerated() {
      let subviewSize = subview.sizeThatFits(proposal)

      var widthWeight: CGFloat = 0
      var heightWeight: CGFloat = 0
      if let proposalWidth = proposal.width {
        widthWeight = max((proposalWidth - subviewSize.width) / 2, 0)
      }

      if let proposalHeight = proposal.height {
        heightWeight = max((proposalHeight - subviewSize.height) / 2, 0)
      }

      let xOffset = CGFloat(index) * pageWidth
      let subviewBounds = CGRect(
        x: bounds.minX + xOffset + widthWeight,
        y: bounds.minY + heightWeight,
        width: bounds.width,
        height: bounds.height
      )

      // 화면 전체 크기를 제안 (ProposedViewSize)
      subview.place(at: subviewBounds.origin, proposal: ProposedViewSize(subviewBounds.size))
    }
  }
}
