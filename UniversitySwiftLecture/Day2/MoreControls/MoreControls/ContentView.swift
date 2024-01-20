//
//  ContentView.swift
//  MoreControls
//
//  Created by Kiyong Kim on 1/16/24.
//

import SwiftUI

struct ContentView: View {
    let names = [
        "jkfe", "Hello", "World", "Kakaka", "Puhaha", "Kekeke",
        "Hohoho", "Hihihi", "Kukuku",
        "jkfe", "Hello", "World", "Kakaka", "Puhaha", "Kekeke",
        "Hohoho", "Hihihi", "Kukuku",
        "jkfe", "Hello", "World", "Kakaka", "Puhaha", "Kekeke",
        "Hohoho", "Hihihi", "Kukuku"
   ]
    var body: some View {
        NavigationView {
            List {
                ForEach(names, id: \.self) { name in
                    NavigationLink {
                        ItemDetailView(name: name)
                    } label: {
                        ItemView(name: name)
                    }
                }
            }
            .navigationTitle("Worlds")
        }
    }
}

#Preview {
    ContentView()
}

struct ItemView: View {
    let name: String
    var body: some View {
        HStack {
            Image(systemName: "pencil.tip.crop.circle.badge.arrow.forward")
            Text("Name: \(name)")
        }
    }
}
