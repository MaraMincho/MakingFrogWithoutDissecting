//
//  TaskModifier.swift
//  TIL_TCA
//
//  Created by MaraMincho on 5/5/24.
//

import Foundation
import SwiftUI

struct Message: Decodable, Identifiable {
    let id: Int
    let from: String
    let text: String
}

struct TaskModifierView: View {
  @State private var messages = [Message]()
  
  var body: some View {
    NavigationView {
      List(messages) { message in
        VStack(alignment: .leading) {
          Text(message.from)
            .font(.headline)
          
          Text(message.text)
        }
      }
      .navigationTitle("Inbox")
      .onAppear{
        print("View is appeard")
      }
      .task {
        print("Task was Started")
        await loadMessages()
        print("Task was end")
      }
    }
  }
  
  func loadMessages() async {
    do {
      let url = URL(string: "https://hws.dev/messages.json")!
      let (data, _) = try await URLSession.shared.data(from: url)
      messages = try JSONDecoder().decode([Message].self, from: data)
    } catch {
      messages = [
        Message(id: 0, from: "Failed to load inbox.", text: "Please try again later.")
      ]
    }
  }
}

#Preview {
  TaskModifierView()
}
