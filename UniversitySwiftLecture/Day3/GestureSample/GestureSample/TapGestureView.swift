//
//  TapGestureView.swift
//  GestureSample
//
//  Created by MaraMincho on 1/17/24.
//

import SwiftUI

struct TapGestureView: View {
  @State var count: Int = 0
  var body: some View {
    VStack {
      Text("Tap Me! \(count)")
        .font(.largeTitle)
        .foregroundStyle(.blue)
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.yellow)
        .gesture(
          TapGesture()
            .onEnded{ _ in
              count += 1
              print("Tap me is tapped.. 🚨")
              return
            }
        )
        .onLongPressGesture {
          count += 10
        }
    }
    .navigationTitle("TapGesture")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  NavigationView{
    TapGestureView()
  }
}
