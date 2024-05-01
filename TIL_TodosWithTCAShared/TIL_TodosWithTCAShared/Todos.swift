//
//  ContentView.swift
//  TIL_TodosWithTCAShared
//
//  Created by MaraMincho on 5/1/24.
//

import SwiftUI
import ComposableArchitecture

struct TodosMainView: View {
  @Bindable
  var store: StoreOf<TodosMain>
  
  var body: some View {
    VStack {
      
      Text("최근 편집한 TODO: \(store.recentEdited.title)")
      
      HStack {
        Text("투두 투두 ")
        Spacer()
        Button("추가") {
          store.send(.tappedCreateTodo)
        }
      }
      ScrollView() {
        VStack {
          ForEach(store.todosContent) { content in
            Text(content.title)
              .onTapGesture {
                store.send(.tappedDetailOfTodos(id: content.id))
              }
          }
        }
      }
    }
    .sheet(item: $store.scope(state: \.todo, action: \.todo)) { store in
      TodoView(store: store)
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
struct TodosMain {
  @ObservableState
  struct State {
    @Shared var todosContent: [TodoContentProperty]
    @Presents var todo: Todo.State? = nil
    @Shared var recentEdited: TodoContentProperty
    init() {
      _recentEdited = .init(TodoContentProperty(title: "", content: ""))
      _todosContent = .init([])
    }
  }
  
  enum Action: Equatable {
    case tappedCreateTodo
    case tappedDetailOfTodos(id: UUID)
    case presentTodo(id: UUID)
    case todo(PresentationAction<Todo.Action>)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .tappedCreateTodo:
        let newTodo = TodoContentProperty(title: "", content: "")
        state.recentEdited = newTodo
        state.todo = .init(todo: state.$recentEdited)
        return .none
      case let .tappedDetailOfTodos(id):
        return .run { send in
          await send(.presentTodo(id: id))
        }
      case let .presentTodo(id):
        if let ind = state.todosContent.enumerated().first(where: {$0.element.id == id})?.offset{
          state.recentEdited = state.todosContent[ind]
          state.todo = .init(todo: state.$recentEdited)
        }
        return .none
      case .todo(.dismiss):
        if let index = state.todosContent.enumerated().first(where: {$0.element.id == state.recentEdited.id})?.offset {
          state.todosContent[index] = state.recentEdited
        }else {
          state.todosContent.append(state.recentEdited)
        }
        return .none
      case .todo:
        return .none
      }
    }
    .ifLet(\.$todo, action: \.todo) {
      Todo()
    }
  }
}
