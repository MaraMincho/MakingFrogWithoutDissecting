// 
//  ChildNavigationView.swift
//  TIL_TCA
//
//  Created by MaraMincho on 7/31/24.
//
import SwiftUI
import ComposableArchitecture

struct ChildNavigationView: View {

  // MARK: Reducer
  @Bindable
  var store: StoreOf<ChildNavigation>
  
  //MARK: Init
  init(store: StoreOf<ChildNavigation>) {
    print("ChildView iniited")
    self.store = store
  }

  // MARK: Content
  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      
    }
  }

  var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: \.scope.path)) {
      ZStack {
        Color.orange.ignoresSafeArea()
        VStack{
          Button {
            store.send(.view(.tappedButton(1)))
          } label: {
            Text("1")
          }
          Button {
            store.send(.view(.tappedButton(2)))
          } label: {
            Text("1")
          }
        }
      }


    } destination: { store in
      EmptyView()
    }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {

  }
  
  private enum Constants {
    
  }
}
