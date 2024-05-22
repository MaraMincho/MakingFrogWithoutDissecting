//
//  ContentView.swift
//  Testttt
//
//  Created by MaraMincho on 5/22/24.
//

import SwiftUI
struct ContentView: View {
  @State private var toNextView : Bool = false
  @Environment(\.dismiss) var dismiss
  var body: some View {
    NavigationStack{
      VStack {
        Button{
          toNextView = true
        } label: {
          Text("BView로 이동")
        }
      }
      .navigationTitle("AView")
      .navigationDestination(
        isPresented: $toNextView) {
          VStack {
            BView()
            CView(text: "asdf")
          }
        }
    }
  }
}

struct BView : View {
  @State private var toNextView : Bool = false
  var body: some View {
    NavigationStack {
      ZStack{
        Color.red
        Button{
          toNextView = true
        } label: {
          Text("CView로 이동")
        }
      }
      .navigationTitle("BView")
      .navigationDestination(
        isPresented: $toNextView,
        destination: {
        CView(text: "asdf")
      })
    }
    
  }
}

struct CView : View {
  init(text: String) {
    self.text = text
  }
  var text: String
  var body: some View {
    ZStack {
      Color.blue
      Text("CView입니다")
    }
    
  }
}
