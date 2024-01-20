//
//  mainView.swift
//  GestureSample
//
//  Created by MaraMincho on 1/17/24.
//

import SwiftUI

struct MainView: View {
  var body: some View {
    NavigationView {
      List {
        NavigationLink{
          TapGestureView()
        }label: {
          Text("Tap & LongPress")
        }
        NavigationLink{
          DragGestureView()
        }label: {
          Text("Drag")
        }
        
        Section("Others") {
          NavigationLink{
            ShapeView()
          }label: {
            Text("Shape")
          }
          NavigationLink{
            AnimationView()
          }label: {
            Text("AnimationView")
          }
        }.navigationTitle("Gestures Test")
      }.navigationTitle("Gestures Test")
    }

  }
}

#Preview {
  MainView()
}
