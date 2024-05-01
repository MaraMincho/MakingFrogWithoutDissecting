//
//  ContentView.swift
//  TIL_TodosWithTCAShared
//
//  Created by MaraMincho on 5/1/24.
//

import SwiftUI
import ComposableArchitecture

struct TodosView: View {
  var store: StoreOf<Todos>
  
  var todo: Todo.State? = nil
  var presented = false
  
  var body: some View {
    VStack {
      HStack {
        Text("투두 투두 ")
        Spacer()
        Button("추가") {
          store.send(.tappedCreateTodo)
        }
      }
      .frame(width: .infinity)
      List(store.todosContent) { content in
        Text(content.title)
          .onTapGesture {
            store.send(.tappedDetailOfTodos(id: content.id))
          }
      }
    }
    .navigationTitle("투두둑 투두둑")
    .padding()
  }
}


struct TodoContentProperty: Equatable, Identifiable {
  var title: String
  var content: String
  var id = UUID()
}


@Reducer
struct Todos {
  @ObservableState
  struct State {
    @Shared var todosContent: [TodoContentProperty]
    var todo: Todo.State? = nil
    init() {
      _todosContent = .init([])
    }
  }
  
  enum Action: Equatable {
    case tappedCreateTodo
    case tappedDetailOfTodos(id: UUID)
    case presentTodo(id: UUID)
    case todo(Todo.Action)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .tappedCreateTodo:
        let newTodo = TodoContentProperty(title: "", content: "")
        state.todosContent.append(newTodo)
        return .run { send in
          await send(.presentTodo(id: newTodo.id))
        }
      case let .tappedDetailOfTodos(id):
        return .run { send in
          await send(.presentTodo(id: id))
        }
      case let .presentTodo(id):
        if let todo = state.todosContent.filter({$0.id == id}).first {
          state.todo = .init(todo: todo)
        }
        return .none
      case .todo:
        return .none
      }
    }
    .ifLet(\.todo, action: \.todo) {
      Todo()
    }
  }
}
