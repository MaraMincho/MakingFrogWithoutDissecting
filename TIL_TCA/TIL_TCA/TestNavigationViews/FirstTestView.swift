// 
//  FirstTestView.swift
//  TIL_TCA
//
//  Created by MaraMincho on 4/24/24.
//
import SwiftUI
import ComposableArchitecture

struct FirstTestView: View {

  // MARK: Reducer
  @Bindable
  var store: StoreOf<FirstTest>

  // MARK: Content
  @ViewBuilder
  private func makeContentView() -> some View {
    VStack {
      Button("asdf") {
        store.send(.tappedButton)
      }
    }
  }

  var body: some View {
    ZStack {
      Color
        .gray
        .ignoresSafeArea()
      VStack {
        makeContentView()
      }
    }
    .onAppear{
      store.send(.onAppear(true))
    }
    .onDisappear{
//      store.send(.onAppear(false))
    }
  }

  private enum Metrics {

  }
  
  private enum Constants {
    
  }
}
