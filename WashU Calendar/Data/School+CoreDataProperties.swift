//
//  School+CoreDataProperties.swift
//  
//
//  Created by Zhuoran Sun on 2020/7/20.
//
//

import Foundation
import CoreData


extension School {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<School> {
        return NSFetchRequest<School>(entityName: "School")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var shortName: String?
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
