import BookFeature
import RealmSwift
import SwiftUI

// MARK: - ContentView

public struct ContentView: View {
  let t = HI()
  public init() {
    let realm = try! Realm()
    let todo = Todo(name: "Do laundry", ownerID: "12")
    try! realm.write {
      realm.add(todo)
    }
    let todos = realm.objects(Todo.self)
    print(todos)
  }

  public var body: some View {
    Text("Hello, World!")
      .padding()
  }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

// MARK: - Todo

class Todo: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var name: String = ""
  @Persisted var status: String = ""
  @Persisted var ownerID: String
  convenience init(name: String, ownerID: String) {
    self.init()
    self.name = name
    self.ownerID = ownerID
  }
}
