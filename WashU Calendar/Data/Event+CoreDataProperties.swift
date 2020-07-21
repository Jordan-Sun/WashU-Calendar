//
//  Event+CoreDataProperties.swift
//  
//
//  Created by Zhuoran Sun on 2020/7/20.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var end: Date?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var start: Date?
    @NSManaged public var section: Section?

}
