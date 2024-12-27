//
//  ContentView.swift
//  EscapingVsNonEscaping
//
//  Created by MaraMincho on 12/27/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
//func test1(completion: () -> Void) -> Int{
//    let myCompletion: () -> Void = {
//        print("complete")
//    }
//    let request = URLRequest(url: .init(string: "https://example.com")!)
//    URLSession.shared.dataTask(with: request) { data, response, error in
//        completion() // ❌ 컴파일 에러 발생
//    }
//    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
//        completion() // ❌ 컴파일 에러 발생
//    }
//    return 1
//}

func test2(completion: @escaping () -> Void) -> Int{
    let myCompletion: () -> Void = {
        print("complete")
    }
    let request = URLRequest(url: .init(string: "https://example.com")!)
    URLSession.shared.dataTask(with: request) { data, response, error in
        completion() // ✅
    }
    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        completion() // ✅
    }
    return 1
}

func test3(completion: () -> String) -> String {
    return completion()
}

func test4(completion: @autoclosure () -> String) -> String {
    return completion()
}

func test5() {
    var myArray = ["Minsu", "Susan", "Chan", "Heize"]
    print(test3{ myArray.removeFirst() })
    print(test3(completion: myArray.removeFirst() )) // ❌ Compile Error

    let myClosure: () -> String = {
        myArray.removeFirst()
    }
    print(test4(completion: myClosure()))
    print(test4{ myArray.removeFirst() }) // ❌ Compile Error
    print(test4(completion: myArray.removeFirst()))
}
