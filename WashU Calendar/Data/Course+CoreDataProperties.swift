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

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var professor: String?
    @NSManaged public var unit: Int16
    @NSManaged public var department: Department?
    @NSManaged public var events: NSSet?
    @NSManaged public var session: Session?
    @NSManaged public var attributes: NSSet?

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

// MARK: Generated accessors for attributes
extension Course {

    @objc(addAttributesObject:)
    @NSManaged public func addToAttributes(_ value: Attribute)

    @objc(removeAttributesObject:)
    @NSManaged public func removeFromAttributes(_ value: Attribute)

    @objc(addAttributes:)
    @NSManaged public func addToAttributes(_ values: NSSet)

    @objc(removeAttributes:)
    @NSManaged public func removeFromAttributes(_ values: NSSet)

}
