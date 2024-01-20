//
//  ShapeView.swift
//  GestureSample
//
//  Created by MaraMincho on 1/18/24.
//

import SwiftUI

struct ShapeView: View {
  var body: some View {
    VStack{
      Color.red
        .frame(width: 200, height: 100)
      Rectangle()
        .stroke()
        .padding()
      Rectangle()
        .stroke(lineWidth: 10)
        .fill(
          LinearGradient(colors: [.black, .blue, .yellow], startPoint: .leading, endPoint: .bottom)
          
        )
        .padding()
      RoundedRectangle(cornerRadius: 20)
        .stroke(lineWidth: 8)
        .padding(.horizontal)
        .padding()
      Capsule()
        .frame(height: 50)
        .padding()
      Capsule()
        .frame(height: 50)
        .padding()
      Ellipse()
      Ellipse()
      Ellipse()
        .frame(width: 50, height: 100)
      Path()
      RadialGradient(
        colors: [.yellow, .red, .blue],
        center: .center,
        startRadius: 20,
        endRadius: 150
      )
      
    }
    .navigationTitle("드로잉스")
  }
}

#Preview {
  NavigationView {
    ShapeView()
  }
}
