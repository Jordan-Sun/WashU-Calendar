//
//  Course+CoreDataProperties.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/17.
//  Copyright © 2020 washu. All rights reserved.
//
//

import Foundation
import CoreData


extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var attributes: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var professor: String?
    @NSManaged public var unit: Int16
    @NSManaged public var department: Department?
    @NSManaged public var events: NSSet?
    @NSManaged public var session: Session?

}

// MARK: Generated accessors for events
extension Course {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}
