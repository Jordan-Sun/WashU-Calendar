//
//  Professor+CoreDataProperties.swift
//  
//
//  Created by Zhuoran Sun on 2020/7/20.
//
//

import Foundation
import CoreData


extension Professor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Professor> {
        return NSFetchRequest<Professor>(entityName: "Professor")
    }

    @NSManaged public var name: String?
    @NSManaged public var courses: NSSet?
    @NSManaged public var department: Department?

}

// MARK: Generated accessors for courses
extension Professor {

    @objc(addCoursesObject:)
    @NSManaged public func addToCourses(_ value: Course)

    @objc(removeCoursesObject:)
    @NSManaged public func removeFromCourses(_ value: Course)

    @objc(addCourses:)
    @NSManaged public func addToCourses(_ values: NSSet)

    @objc(removeCourses:)
    @NSManaged public func removeFromCourses(_ values: NSSet)

}
