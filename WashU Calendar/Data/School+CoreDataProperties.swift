//
//  School+CoreDataProperties.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/18.
//  Copyright © 2020 washu. All rights reserved.
//
//

import Foundation
import CoreData


extension School {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<School> {
        return NSFetchRequest<School>(entityName: "School")
    }

    @NSManaged public var name: String?
    @NSManaged public var departments: NSSet?

}

// MARK: Generated accessors for departments
extension School {

    @objc(addDepartmentsObject:)
    @NSManaged public func addToDepartments(_ value: Department)

    @objc(removeDepartmentsObject:)
    @NSManaged public func removeFromDepartments(_ value: Department)

    @objc(addDepartments:)
    @NSManaged public func addToDepartments(_ values: NSSet)

    @objc(removeDepartments:)
    @NSManaged public func removeFromDepartments(_ values: NSSet)

}
