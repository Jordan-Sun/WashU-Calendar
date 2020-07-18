//
//  Attribute+CoreDataProperties.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/17.
//  Copyright © 2020 washu. All rights reserved.
//
//

import Foundation
import CoreData


extension Attribute {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attribute> {
        return NSFetchRequest<Attribute>(entityName: "Attribute")
    }

    @NSManaged public var name: String?
    @NSManaged public var course: Course?

}
