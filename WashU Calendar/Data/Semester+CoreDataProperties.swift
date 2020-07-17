//
//  Semester+CoreDataProperties.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/17.
//  Copyright © 2020 washu. All rights reserved.
//
//

import Foundation
import CoreData


extension Semester {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Semester> {
        return NSFetchRequest<Semester>(entityName: "Semester")
    }

    @NSManaged public var name: String?
    @NSManaged public var sessions: NSSet?

}

// MARK: Generated accessors for sessions
extension Semester {

    @objc(addSessionsObject:)
    @NSManaged public func addToSessions(_ value: Session)

    @objc(removeSessionsObject:)
    @NSManaged public func removeFromSessions(_ value: Session)

    @objc(addSessions:)
    @NSManaged public func addToSessions(_ values: NSSet)

    @objc(removeSessions:)
    @NSManaged public func removeFromSessions(_ values: NSSet)

}
