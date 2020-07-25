//
//  Section+CoreDataProperties.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/21.
//  Copyright © 2020 washu. All rights reserved.
//
//

import Foundation
import CoreData


extension Section {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Section> {
        return NSFetchRequest<Section>(entityName: "Section")
    }

    @NSManaged public var days: String?
    @NSManaged public var desc: String?
    @NSManaged public var end: Date?
    @NSManaged public var id: String?
    @NSManaged public var start: Date?
    @NSManaged public var type: String?
    @NSManaged public var color: NSObject?
    @NSManaged public var location: String?
    @NSManaged public var course: Course?
    @NSManaged public var events: NSSet?

}

// MARK: Generated accessors for events
extension Section {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}
