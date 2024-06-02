//
//  ContentView.swift
//  TIL_SwiftData
//
//  Created by MaraMincho on 6/2/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  
  @Query var todos: [Todo]
  @Environment(\.modelContext) private var modelContext
  @State var someText: String = ""
  var body: some View {
    
    NavigationStack {
      VStack {
        NavigationLink(value: Todo(title: "", todoContent: "")) {
          Text("add todo")
        }

        List {
          ForEach(todos) { todo in
            NavigationLink(value: todo) {
              Text(todo.title)
            }
          }
        }
      }
      .navigationTitle("TODOS")
      .navigationDestination(for: Todo.self) { todo in
        TodoView(todoElement: todo)
      }
    }
    .onAppear{
    }
  }
}

@Model
final class Todo {
  var title: String
  var todoContent: String
  
  init(title: String, todoContent: String) {
    self.title = title
    self.todoContent = todoContent
  }
}

struct TodoView: View {
  var todoElement: Todo
  @State var contentTextFieldText: String
  @State var titleTextFieldText: String
  @Environment(\.modelContext) private var modelContext
  init(todoElement: Todo) {
    self.todoElement = todoElement
    contentTextFieldText = todoElement.todoContent
    titleTextFieldText = todoElement.title
  }
  
  @Environment(\.dismiss) var dismiss
  var body: some View {
    VStack {
      HStack {
        Button {
          
          todoElement.title = titleTextFieldText
          todoElement.todoContent = contentTextFieldText
          modelContext.insert(todoElement)
          dismiss()
        } label: {
          Text("저장")
        }
        
        Button {
          modelContext.delete(todoElement)
          dismiss()
        } label: {
          Text("제거")
        }
      }
   

      TextField("", text: $titleTextFieldText, axis: .vertical)
        .background(Color.gray.opacity(0.8))
        .padding()
      
      TextField("", text: $contentTextFieldText, axis: .vertical)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.5))
        .font(.largeTitle)
      Spacer()
    }
  }
}
