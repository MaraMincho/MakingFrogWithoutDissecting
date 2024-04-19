//
//  ContentView.swift
//  TIL_SwiftUINavigation
//
//  Created by MaraMincho on 4/18/24.
//

import SwiftUI

struct ContentView: View {
  @State var path: [NextPath] = []

  var body: some View {
    TestNavigationStack(path: $path) // 변경된 부분
  }
}

struct TestNavigationStack: View {
  @Binding var path: [NextPath]
  @State var titleValue = "안녕"
  
  var re : Color {[Color.red,Color.orange,Color.blue,Color.gray,Color.indigo].randomElement()! }
  var body: some View {
    NavigationStack(path: $path) {
      VStack {
        Button {
          path.append(.SomeColorView(.yellow, 3))
        } label: {
          Text("나랑노랑")
        }
        Button {
          self.titleValue = self.titleValue + self.titleValue.reversed()
          path.append(.secondView(titleValue))
        } label: {
          Text("애기야 가자")
        }
        
      }
      .navigationDestination(for: NextPath.self) { item in
        switch item {
        case let .SomeColorView(color, value) :
          SomeColorView(color: color, order: value, path: $path)
        case let .secondView(text) :
          SecondView(titleText: text)
        }
      }
    }
  }
}

enum NextPath: Hashable, Equatable {
  case SomeColorView(Color, Int)
  case secondView(String)
}

struct SomeColorView: View {
  var color: Color
  var order: Int
  @Binding var path: [NextPath]
  var body: some View {
    color.overlay {
      VStack {
        Button {
          path.append(.SomeColorView([Color.red,Color.orange,Color.blue,Color.gray,Color.indigo].randomElement()!, 3))
        } label: {
          Text("랜덤푸시")
        }
        Button {
          path.removeAll()
        } label: {
          Text("초기화")
        }
      }
    }
  }
}

struct SecondView: View {
  var titleText: String
  var body: some View {
    VStack{
      Text(titleText)
    }
  }
}
