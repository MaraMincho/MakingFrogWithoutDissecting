//
//  SceneDelegate.swift
//  TIL_Realm
//
//  Created by MaraMincho on 2/6/24.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = .init(windowScene: windowScene)
    let config = Realm.Configuration(schemaVersion: 2)
    // Use this configuration when opening realms
    Realm.Configuration.defaultConfiguration = config
    
    window?.rootViewController = ViewController()
    window?.makeKeyAndVisible()
    //openRealm()
  }
  
  func openRealm() {
    guard let realm = try? Realm() else { return }
    let todo = Todo(name: "아야어여오유우이" ,ownerId: "정다함")
    try? realm.write {
      realm.add(todo)
    }
    
    let todos = realm.objects(Todo.self)
    
    let res = todos.where {$0.name == "아야어여오유우이"}
    print(res)
  }
}

class Todo: Object {
   @Persisted(primaryKey: true) var _id: ObjectId
   @Persisted var name: String = ""
   @Persisted var status: String = ""
   @Persisted var ownerId: String
   convenience init(name: String, ownerId: String) {
       self.init()
       self.name = name
       self.ownerId = ownerId
   }
}
