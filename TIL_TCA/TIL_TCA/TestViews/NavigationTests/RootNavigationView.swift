// 
//  RootNavigationView.swift
//  TIL_TCA
//
//  Created by MaraMincho on 7/31/24.
//
import SwiftUI
import ComposableArchitecture
import SwiftUINavigationCore

struct RootNavigationView: View {

  // MARK: Reducer
  @Bindable
  var store: StoreOf<RootNavigation>
  
  //MARK: Init
  init(store: StoreOf<RootNavigation>) {
    self.store = store
  }

  // MARK: Content
  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      Button {
        store.send(.tappedView)
      } label: {
        Text("push View that contains ScrollView")
      }

      Button {
        store.send(.tappedNestedButton)
      } label: {
        Text("push View That is not contain ScrollView")
      }

    }
  }

  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        makeContentView()
          .navigationDestination(item: $store.scope(state: \.child, action: \.child)) { childStore in
            
            ChildNavigationView(store: childStore)
          }
          .navigationDestination(item: $store.scope(state: \.ns, action: \.ns)) { store in
            NestedView(store: store)
          }

      }
    }
    .navigationBarBackButtonHidden()
    .onAppear{
      store.send(.onAppear(true))
    }
  }

  private enum Metrics {

  }
  
  private enum Constants {
    
  }
}
