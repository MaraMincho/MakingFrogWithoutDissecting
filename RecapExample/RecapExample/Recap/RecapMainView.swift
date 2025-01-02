//
//  RecapMainView.swift
//  SLRecap
//
//  Created by MaraMincho on 12/30/24.
//  Copyright © 2024 com.swimlight. All rights reserved.
//

import SwiftUI

// MARK: - RecapMainView

public struct RecapMainView<Content: View>: View {
  @Bindable
  var controller: RecapMainController

  @ViewBuilder
  var content: () -> Content

  public init(
    controller: RecapMainController,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.controller = controller
    self.content = content
  }

  public var body: some View {
    VStack(alignment: .center, spacing: 10) {
      makeRecapStatue()
      GeometryReader { proxy in
        RecapLayout(currentPageCount: controller.updatePageCount(_:)) {
          content()
            .ignoresSafeArea(.all)
        }
        .offset(x: -CGFloat(controller.currentPage) * proxy.size.width)
      }
    }
    .padding(.top, 10)
    .overlay {
      makeOverlayView()
    }
  }

  @ViewBuilder
  private func makeRecapStatue() -> some View {
    let pageCount = controller.pageCount
    let data: [Int] = (0 ..< pageCount).map { $0 }
    HStack(alignment: .center, spacing: 4) {
      ForEach(data, id: \.self) { currentIndex in
        if currentIndex < controller.currentPage {
          makeRecapStatusWhiteBarView()
        } else if currentIndex == controller.currentPage {
          makeCurrentPageRecapStatusView()
        } else {
          makeRecapStatusGrayBarView()
        }
      }
    }
    .padding(.horizontal, 12)
  }

  @ViewBuilder
  private func makeCurrentPageRecapStatusView() -> some View {
    makeRecapStatusGrayBarView()
      .overlay(alignment: .leading) {
        GeometryReader { proxy in
          let width = proxy.size.width
          let widthOffset = -width + width * controller.currentDurationPercentage
          makeRecapStatusWhiteBarView()
            .animation(.linear(duration: 0.1), value: widthOffset)
            .offset(x: widthOffset)
        }
      }
      .clipShape(RoundedRectangle(cornerRadius: 4))
  }

  @ViewBuilder
  private func makeRecapStatusWhiteBarView() -> some View {
    Color
      .white
      .frame(height: 15)
      .clipShape(RoundedRectangle(cornerRadius: 4))
  }

  @ViewBuilder
  private func makeRecapStatusGrayBarView() -> some View {
    Color
      .gray
      .opacity(0.5)
      .frame(height: 15)
      .clipShape(RoundedRectangle(cornerRadius: 4))
  }

  @ViewBuilder
  private func makeOverlayView() -> some View {
    HStack(spacing: 0) {
      Color
        .clear
        .contentShape(Rectangle())
        .onTapGesture {
          controller.goPrevPage()
        }
      Color
        .clear
        .contentShape(Rectangle())
        .onTapGesture {
          controller.goNextPage()
        }
    }
  }
}
