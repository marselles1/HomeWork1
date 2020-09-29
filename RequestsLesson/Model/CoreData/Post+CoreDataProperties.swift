//
//  Post+CoreDataProperties.swift
//  RequestsLesson
//
//  Created by marsel on 28.08.2020.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var id: Int64
    @NSManaged public var text: String?
    @NSManaged public var image: String?
    @NSManaged public var likes: Int64
    @NSManaged public var comments: Int64
    @NSManaged public var reposts: Int64
    @NSManaged public var date: Date?

}
