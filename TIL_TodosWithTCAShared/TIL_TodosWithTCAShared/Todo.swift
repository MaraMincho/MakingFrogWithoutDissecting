//
//  ContentView.swift
//  TIL_TodosWithTCAShared
//
//  Created by MaraMincho on 5/1/24.
//

import SwiftUI
import ComposableArchitecture

struct TodoView: View {
  @Bindable
  var store: StoreOf<Todo>
  var body: some View {
    VStack {
      TextField("", text: $store.todo.title, prompt: Text("제목을 입력하세요"))
      
      Color.gray
        .frame(maxWidth: .infinity, maxHeight: 4)
      TextField("", text: $store.todo.content, axis: .horizontal)
    }
    .padding()
  }
}


@Reducer
struct Todo {
  @ObservableState
  struct State {
    @Shared var todo: TodoContentProperty
    init(todo: TodoContentProperty) {
      _todo = .init(todo)
    }
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<Todo.State>)
    case tappedCreateTodo
    case tappedDetailOfTodos
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
