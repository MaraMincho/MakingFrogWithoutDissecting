//
//  AnimationView.swift
//  GestureSample
//
//  Created by MaraMincho on 1/18/24.
//

import SwiftUI

struct AnimationView: View {
  @State var spinning = false
  @State var finished = true
  @State var angle = Angle.zero
  var body: some View {
    VStack{
      Image(systemName: "arrow.clockwise.circle")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundStyle(.purple)
        .animation(.linear(duration: 1).repeatForever(autoreverses: false), body: { view in
          view.rotationEffect(.degrees(spinning ? 360 : 0))
        })
        
        .padding()
      Toggle(isOn: $spinning, label: {
        Text("Label")
          .font(.title)
      })
      .padding()
    }
    .onAppear {
      spinning = true
    }
  }
}

#Preview {
    AnimationView()
}
