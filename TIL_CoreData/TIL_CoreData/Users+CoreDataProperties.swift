//
//  Users+CoreDataProperties.swift
//  TIL_CoreData
//
//  Created by MaraMincho on 2/6/24.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var age: Int32
    @NSManaged public var id: Int32
    @NSManaged public var devices: [String]?
    @NSManaged public var name: String?
    @NSManaged public var signupDate: Date?

}

extension Users : Identifiable {

}
