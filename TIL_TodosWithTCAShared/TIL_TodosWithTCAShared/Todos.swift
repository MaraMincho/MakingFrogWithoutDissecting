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
      
      ZStack {
        Color
          .green
          .frame(height: 60)
          .clipShape(RoundedRectangle(cornerRadius: 8))
        HStack {
          Text("투두 투두 ")
          Spacer()
          Button("추가") {
            store.send(.tappedCreateTodo)
          }
        }
        .padding()
      }
      
      ScrollView() {
        VStack {
          ForEach(store.todosContent.todo) { content in
            ZStack {
              Color
                .black
                .opacity(0.1)
                .frame(height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
              HStack {
                Text(content.title)
                  .onTapGesture {
                    store.send(.tappedDetailOfTodos(id: content.id))
                  }
                Spacer()
                Button {
                  store.send(.deleteTodo(id: content.id))
                } label: {
                  Image(systemName: "pencil")
                }
              }
              .frame(maxWidth: .infinity)
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


struct TodoContentProperty: Codable, Equatable, Identifiable {
  var title: String
  var content: String
  var id = UUID()
}


@Reducer
struct TodosMain {
  @ObservableState
  struct State {
    @Shared(.todosContent) var todosContent = TodosContentProperty(todo: [])
    @Presents var todo: Todo.State? = nil
    @Shared var recentEdited: TodoContentProperty
    init() {
      _recentEdited = .init(TodoContentProperty(title: "", content: ""))
    }
  }
  
  enum Action: Equatable {
    case tappedCreateTodo
    case tappedDetailOfTodos(id: UUID)
    case presentTodo(id: UUID)
    case todo(PresentationAction<Todo.Action>)
    case deleteTodo(id: UUID)
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
      case let .deleteTodo(id):
        state.todosContent = state.todosContent.filter{$0.id != id}
        return .none
      }
    }
    .ifLet(\.$todo, action: \.todo) {
      Todo()
    }
  }
}

extension PersistenceReaderKey where Self == AppStorageKey<TodosContentProperty> {
  fileprivate static var todosContent: Self {
    appStorage("TodosContentProperty")
  }
}

struct TodosContentProperty: Equatable, Codable {
  var todo: [TodoContentProperty]
  init(todo: [TodoContentProperty]) {
    self.todo = todo
  }
}
