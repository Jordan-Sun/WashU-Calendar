//
//  CoreDataController.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/19.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CoreDataController {
    
    // Core Data Component
    /// App delegate
    private var appDelegate:  AppDelegate
    /// Core data context
    private var context: NSManagedObjectContext
    
    // Debug Component
    var testSchool: School!
    var testDepartment: Department!
    var testSemester: Semester!
    var testSession: Session!
    
    init(appDelegate: AppDelegate, context: NSManagedObjectContext) {
        self.appDelegate = appDelegate
        self.context = context

        //debug
        testSchool = addSchoolToCoreData(fullName: "Test School")
        testDepartment = addDepartmentToCoreData(fullName: "Test Department", code: "000", to: testSchool)
        testSemester = addSemesterToCoreData(name: "Test Semester")
        testSession = addSessionToCoreData(name: "Test Session", semester: testSemester)
    }
    
    
}

// Core Data Interactions

extension CoreDataController {
    
    /// Add a new school to core data.
    /// - Parameters:
    ///   - fullName: the full name of the school.
    ///   - shortName: (optional) the short name of the school.
    /// - Returns: an instance of the created school.
    @discardableResult func addSchoolToCoreData(fullName: String, shortName: String? = nil) -> School {
        let newSchool = School(entity: School.entity(), insertInto: context)
        newSchool.fullName = fullName
        newSchool.shortName = shortName ?? fullName
        appDelegate.saveContext()
        return newSchool
    }
    
    /// Add a new department to core data.
    /// - Parameters:
    ///   - fullName: the full name of the department.
    ///   - shortName: (optional) the short name of the department.
    ///   - code: the code of the department.
    ///   - school: the school of which the department belongs to.
    /// - Returns: an instance of the created department.
    @discardableResult func addDepartmentToCoreData(fullName: String, shortName: String? = nil, code: String, to school: School) -> Department {
        let newDepartment = Department(entity: Department.entity(), insertInto: context)
        newDepartment.fullName = fullName
        newDepartment.shortName = shortName ?? fullName
        newDepartment.code = code
        newDepartment.school = school
        appDelegate.saveContext()
        return newDepartment
    }
    
    /// Add a new professor to core data.
    /// - Parameters:
    ///   - name: the name of the professor.
    ///   - department: the department of which the professor belongs to.
    /// - Returns: an instance of the created professor.
    @discardableResult func addProfessorToCoreData(name: String, to department: Department) -> Professor {
        let newProfessor = Professor(entity: Professor.entity(), insertInto: context)
        newProfessor.name = name
        newProfessor.department = department
        appDelegate.saveContext()
        return newProfessor
    }
    
    /// Add a new semester to core data
    /// - Parameter name: the name of the semester.
    /// - Returns: an instance of the created semester.
    @discardableResult func addSemesterToCoreData(name: String) -> Semester {
        let newSemester = Semester(entity: Semester.entity(), insertInto: context)
        newSemester.name = name
        appDelegate.saveContext()
        return newSemester
    }
    
    /// Add a new session to core data
    /// - Parameter name: the name of the session.
    /// - Returns: an instance of the created session.
    @discardableResult func addSessionToCoreData(name: String, semester: Semester) -> Session {
        let newSession = Session(entity: Session.entity(), insertInto: context)
        newSession.name = name
        newSession.semester = semester
        appDelegate.saveContext()
        return newSession
    }
    
    /// Add a new attribute to core data
    /// - Parameters:
    ///   - name: the name of the attribute
    /// - Returns: an instance of the created attribute.
    @discardableResult func addAttributeToCoreData(name: String) -> Attribute {
        let newAttribute = Attribute(entity: Attribute.entity(), insertInto: context)
        newAttribute.name = name
        appDelegate.saveContext()
        return newAttribute
    }
    
    /// Add a new course to core data.
    /// - Parameters:
    ///   - name: the name of the course.
    ///   - id: the id of the course.
    ///   - department: the department of which the course belongs to.
    ///   - professor: the professor who teaches the course.
    ///   - session: the session of which the course belongs to.
    ///   - attributes: an array of attributes that the course conforms to.
    /// - Returns: an instance of the created course.
    @discardableResult func addCourseToCoreData(name: String, id: String, department: Department, session: Session, professor: Professor? = nil, attributes: [Attribute]? = nil) -> Course {
        let newCourse = Course(entity: Course.entity(), insertInto: context)
        newCourse.name = name
        newCourse.id = id
        newCourse.department = department
        newCourse.professor = professor
        newCourse.session = session
        if let attributes = attributes {
            newCourse.addToAttributes(NSSet(array: attributes))
        }
        appDelegate.saveContext()
        return newCourse
    }
    
    /// Add a new event to core data.
    /// - Parameters:
    ///   - start: the start time of the event.
    ///   - end: the end time of the event.
    ///   - location: the location where the event takes place.
    ///   - course: the course of which the event belongs to.
    /// - Returns: an instance of the created event.
    @discardableResult func addEventToCoreData(name: String, from start: Date, to end: Date, to course: Course, at location: String? = nil) -> Event {
        let newEvent = Event(entity: Event.entity(), insertInto: context)
        newEvent.name = name
        newEvent.start = start
        newEvent.end = end
        newEvent.location = location
        newEvent.course = course
        appDelegate.saveContext()
        return newEvent
    }
    
    /// An alternative way to add a new event to core data.
    @discardableResult func addEventToCoreData(name: String, interval: DateInterval, to course: Course, at location: String? = nil) -> Event {
        let newEvent = Event(entity: Event.entity(), insertInto: context)
        newEvent.name = name
        newEvent.start = interval.start
        newEvent.end = interval.end
        newEvent.location = location
        newEvent.course = course
        appDelegate.saveContext()
        return newEvent
    }
    
}

// Debug functions

extension CoreDataController {
    
    func addTestDataToCoreData() {
        
        for i in 1 ... 10 {
            let newCourse = addCourseToCoreData(name: "Test Course \(i)", id: "000", department: testDepartment, session: testSession)
            for j in 1 ... 10 {
                addEventToCoreData(name: "Test Course \(i) Event \(j)",interval: .init(start: Date(), duration: Double.random(in: 1.0 ... 10.0) * 60), to: newCourse)
            }
        }
        
    }
    
}
