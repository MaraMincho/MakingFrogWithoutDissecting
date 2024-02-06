//
//  CoreDatamanager.swift
//  TIL_CoreData
//
//  Created by MaraMincho on 2/6/24.
//

import UIKit
import CoreData
import OSLog

final class CoreDataManager {
  static let shared = CoreDataManager()
  init() {
    
  }
  
  let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Users")
    container.loadPersistentStores { description, error in
      if let error {
        fatalError("Unresolved Error, \(error.localizedDescription)")
      }
    }
    return container
  }()
  
  lazy var context = persistentContainer.viewContext
  let modelName = "Users"
  
  func getUsers(ascending: Bool = false) -> [Users] {
    var models: [Users] = []
    
    let idSort = NSSortDescriptor(key: "id", ascending: ascending)
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: modelName)
    fetchRequest.sortDescriptors = [idSort]
    
    do {
      let fetchResult = try context.fetch(fetchRequest) as? [Users]
      models = fetchResult ?? []
    }catch {
      Logger().error("\(error.localizedDescription)")
    }
    return models
  }
  
  func saveUsers(id: Int32, name: String, age: Int32, date: Date, devices: [String], onSuccess: @escaping ((Bool) -> Void)) {
    
    guard let entity = NSEntityDescription.entity(forEntityName: modelName, in: context) else {
      onSuccess(false)
      return
    }
    
    if let user = NSManagedObject(entity: entity, insertInto: context) as? Users {
      user.id = id
      user.name = name
      user.age = age
      user.signupDate = date
      user.devices = devices.description
      try? context.save()
    }
    
  }
}
