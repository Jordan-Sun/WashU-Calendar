//
//  Course+CoreDataProperties.swift
//  
//
//  Created by Zhuoran Sun on 2020/7/20.
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
    @NSManaged public var unit: Int16
    @NSManaged public var desc: String?
    @NSManaged public var attributes: NSSet?
    @NSManaged public var department: Department?
    @NSManaged public var sections: NSSet?
    @NSManaged public var professor: Professor?
    @NSManaged public var session: Session?

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

// MARK: Generated accessors for sections
extension Course {

    @objc(addSectionsObject:)
    @NSManaged public func addToSections(_ value: Section)

    @objc(removeSectionsObject:)
    @NSManaged public func removeFromSections(_ value: Section)

    @objc(addSections:)
    @NSManaged public func addToSections(_ values: NSSet)

    @objc(removeSections:)
    @NSManaged public func removeFromSections(_ values: NSSet)

}
