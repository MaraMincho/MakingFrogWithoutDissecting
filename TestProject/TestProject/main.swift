//
//  main.swift
//  TestProject
//
//  Created by MaraMincho on 2023/08/10.
//

import Foundation

print("Hello, World!")

struct App {
    var contacts = [String]() {
        willSet {
            print("")
            print("Current value is: \(contacts)")
            print("New value will be: \(newValue)")
        }

        didSet {
            print("There are now \(contacts.count) contacts.")
            print("Old value was \(oldValue)")
        }
    }
}

var app = App()
app.contacts.append("Adrian E")
app.contacts.append("Allen W")
app.contacts.append("Ish S")
