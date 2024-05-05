//
//  GridExample.swift
//  TIL_TCA
//
//  Created by MaraMincho on 5/2/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct GridExample{
  
  @ObservableState
  struct State {
    var contents: [GirdContent] = [
      .init(name: "assd"),
      .init(name: "asdfsfsd"),
      .init(name: "ㅁ니ㅏㅇ런ㅇ미ㅏㄹ"),
      .init(name: "asdfsfsd"),
      .init(name: "asdfsfsd"),
      .init(name: "asdfsfsd"),
      .init(name: "ㅁ니ㅏㅇ런ㅇ미ㅏㄹ"),
    ]
  }
  enum Action {
    case onAppear
    case action(ind: Int)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .action(ind):
        print(ind)
        return .none
      case .onAppear:
        return .none
      }
    }
  }
}

struct GridExampleView: View {
  @Bindable
  var store: StoreOf<GridExample>
  var body: some View {
    ZStack {
      Color.black.opacity(0.1)
      VStack {
        Text("하이용")
        let item = GridItem(.adaptive(minimum: 100), spacing: 30)
        let columns = Array(repeating: item, count: 3)
        

        LazyVGrid(columns: [.init(.adaptive(minimum: 40), spacing: 5, alignment: .center)], alignment: .leading, spacing: 5) {
          ForEach(0..<store.contents.count) { index in
            
            Text(index % 3 == 0 ? store.contents[index].id.description: store.contents[index].name.description)
              .font(.title2)
              .backgroundStyle(Color.blue)
              .padding()
          }
        }
        .background(Color.green)
      }
    }
   
  }
}

struct GirdContent: Identifiable {
  let id = UUID()
  let name: String
}
