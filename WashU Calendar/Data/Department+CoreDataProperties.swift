//
//  Department+CoreDataProperties.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/18.
//  Copyright © 2020 washu. All rights reserved.
//
//

import Foundation
import CoreData


extension Department {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Department> {
        return NSFetchRequest<Department>(entityName: "Department")
    }

    @NSManaged public var code: String?
    @NSManaged public var fullName: String?
    @NSManaged public var shortName: String?
    @NSManaged public var courses: NSSet?
    @NSManaged public var professors: NSSet?
    @NSManaged public var school: School?

}

// MARK: Generated accessors for courses
extension Department {

    @objc(addCoursesObject:)
    @NSManaged public func addToCourses(_ value: Course)

    @objc(removeCoursesObject:)
    @NSManaged public func removeFromCourses(_ value: Course)

    @objc(addCourses:)
    @NSManaged public func addToCourses(_ values: NSSet)

    @objc(removeCourses:)
    @NSManaged public func removeFromCourses(_ values: NSSet)

}

// MARK: Generated accessors for professors
extension Department {

    @objc(addProfessorsObject:)
    @NSManaged public func addToProfessors(_ value: Professor)

    @objc(removeProfessorsObject:)
    @NSManaged public func removeFromProfessors(_ value: Professor)

    @objc(addProfessors:)
    @NSManaged public func addToProfessors(_ values: NSSet)

    @objc(removeProfessors:)
    @NSManaged public func removeFromProfessors(_ values: NSSet)

}
