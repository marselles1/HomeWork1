//
//  User+CoreDataProperties.swift
//  RequestsLesson
//
//  Created by marsel on 28.08.2020.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var id: Int64
    @NSManaged public var lastName: String?
    @NSManaged public var photo: String?
    @NSManaged public var token: String?

}
