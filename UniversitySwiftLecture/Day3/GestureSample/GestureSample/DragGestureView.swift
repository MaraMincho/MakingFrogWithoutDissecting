//
//  DragGestureView.swift
//  GestureSample
//
//  Created by MaraMincho on 1/17/24.
//

import SwiftUI

func + (a: CGSize, b: CGSize) -> CGSize {
  return .init(width: a.width + b.width, height: a.height + b.height)
}

struct DragGestureView: View {
  @State var globPos = CGSize.zero
  @State var globFinal = CGSize.zero
  
  var body: some View {
    VStack {
      Image(systemName: "figure.run")
        .font(.largeTitle)
        .scaleEffect(3)
        .offset(globFinal + globPos)
        .gesture(
          DragGesture()
            .onChanged{ value in
              globPos = value.translation
            }
            .onEnded{ value in
              globFinal = globFinal + globPos
              globPos = .zero
            }
        )
    }
    .navigationTitle("Drag")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  NavigationView{
    DragGestureView()
  }
}
