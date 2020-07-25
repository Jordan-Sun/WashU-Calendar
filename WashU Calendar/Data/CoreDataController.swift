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
    
    // Environmental Variables
    /// App delegate
    private var appDelegate:  AppDelegate
    /// Core data context
    private var context: NSManagedObjectContext
    
    // Fetched Results Controllers
    /// Core data fetched result controller
    private var eventFetchedResultController: NSFetchedResultsController<Event>!
    
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
        let calendar = Calendar.current
        testSession = try! addSessionToCoreData(name: "Test Session", start: calendar.date(from: DateComponents(year: 2020, month: 7, day: 1))!, end: calendar.date(from: DateComponents(year: 2020, month: 9, day: 1))!, to: testSemester)
    }
    
}

// Query

extension CoreDataController {
    
    
    /// Performs an event fetch request.
    /// - Parameter date: A date that indicates the day that fetched events should take place on, nil if no constraints.
    /// - Returns: An array of fetched events, nil if failed to fetch events
    func fetchEventRequest(on date: Date? = nil) -> [Event]? {
        
        // Initialize fetch request
        let request = Event.fetchRequest() as NSFetchRequest<Event>
        
        // Apply predicate if date is not nil
        if let date = date {
            let calendar = Calendar.current
            let dayStart = calendar.startOfDay(for: date) as NSDate
            guard let dayEnd = calendar.date(byAdding: DateComponents(day: 1), to: dayStart as Date) as NSDate? else {
                print("Fail to compute the end of day for date: \(date).")
                return nil
            }
            let predicate = NSPredicate(format: "(start >= %@) AND (start <= %@)", dayStart, dayEnd)
            request.predicate = predicate
        }
        
        // Apply sort descriptors
        let sort = NSSortDescriptor(key: #keyPath(Event.start), ascending: true)
        request.sortDescriptors = [sort]
        
        // Try to perform fetch request
        do {
            eventFetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try eventFetchedResultController.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return eventFetchedResultController.fetchedObjects
        
    }
    
}

// Save

extension CoreDataController {
    
    enum addToCoreDataError: Error {
        case endPreceedsStartDay
        case endPreceedsStartTime
        case invalidRepeatDays
    }
    
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
    /// - Parameters:
    ///   - name: the name of the session.
    ///   - start: the start of the session.
    ///   - end: the end of the session.
    ///   - semester: the semester of which the session belongs to.
    /// - Returns: an instance of the created session.
    /// - Throws: an error if the end date input preceeds the start date input.
    @discardableResult func addSessionToCoreData(name: String, start: Date, end: Date, to semester: Semester) throws -> Session {
        
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: start)
        let endDay = calendar.startOfDay(for: end)
        guard startDay <= endDay else {
            throw addToCoreDataError.endPreceedsStartDay
        }
        
        let newSession = Session(entity: Session.entity(), insertInto: context)
        newSession.name = name
        newSession.start = startDay
        newSession.end = endDay
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
    ///   - session: the session of which the course belongs to.
    ///   - desc: the description of the course.
    ///   - professor: the professor who teaches the course.
    ///   - attributes: an array of attributes that the course conforms to.
    /// - Returns: an instance of the created course.
    @discardableResult func addCourseToCoreData(name: String, id: String, to department: Department, to session: Session, desc: String? = nil, by professor: Professor? = nil, attributes: [Attribute]? = nil) -> Course {
        let newCourse = Course(entity: Course.entity(), insertInto: context)
        newCourse.name = name
        newCourse.id = id
        newCourse.department = department
        newCourse.session = session
        newCourse.professor = professor
        newCourse.desc = desc
        if let attributes = attributes {
            newCourse.addToAttributes(NSSet(array: attributes))
        }
        appDelegate.saveContext()
        return newCourse
    }
    
    /// Add a new section to core data.
    /// - Parameters:
    ///   - id: the id of the section.
    ///   - start: the start time and day of the section.
    ///   - end: the end time and day of the section.
    ///   - days: a string of length 7 and format #"[M-][T-][W-][R-][F-][S-][U-]"# that indicates the days of a week on which events takes place.
    ///   - course: the course of which the section belongs to.
    ///   - desc: the description of the course.
    ///   - autoGeneratesEvents: a boolean indicating whether the function should automatically generate corresponding events.
    /// - Returns: an instance of the created section.
    /// - Throws: an error if the end date input preceeds the start date input.
    @discardableResult func addSectionToCoreData(id: String, start: Date, end: Date, repeat days: String, to course: Course, desc: String? = nil, color: UIColor = .secondarySystemBackground, at location: String? = nil, autogen autoGeneratesEvents: Bool = true) throws -> Section {
        
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: start)
        let endDay = calendar.startOfDay(for: end)
        guard startDay <= endDay else {
            throw addToCoreDataError.endPreceedsStartDay
        }
        
        let startTime = start.timeIntervalSince(startDay)
        let endTime = end.timeIntervalSince(endDay)
        guard startTime <= endTime else {
            throw addToCoreDataError.endPreceedsStartTime
        }
        
        guard days.count == 7 else {
            throw addToCoreDataError.invalidRepeatDays
        }
        guard days.range(of: #"[M-][T-][W-][R-][F-][S-][U-]"#, options: .regularExpression) != nil else {
            throw addToCoreDataError.invalidRepeatDays
        }
        
        let newSection = Section(entity: Section.entity(), insertInto: context)
        newSection.id = id
        newSection.desc = desc
        newSection.start = start
        newSection.end = end
        newSection.days = days
        newSection.course = course
        newSection.color = color
        newSection.location = location
        appDelegate.saveContext()
        
        let weekdayDict = ["-","U","M","T","W","R","F","S"]
        if autoGeneratesEvents {
            var currentDay = startDay
            while currentDay <= endDay {
                let weekday = weekdayDict[calendar.component(.weekday, from: currentDay)]
                if days.contains(weekday) {
                    do {
                        try addEventToCoreData(name: "\(course.name!) \(id)", from: currentDay.addingTimeInterval(startTime), to: currentDay.addingTimeInterval(endTime), to: newSection, color: color,at: location)
                    } catch {
                        print("Fail to auto generate event for section: \(course.name!) \(id)")
                    }
                }
                currentDay = calendar.date(byAdding: DateComponents(day: 1), to: currentDay)!
            }
        }
        
        return newSection
        
    }
    
    
    /// Add a new event to core data.
    /// - Parameters:
    ///   - start: the start time of the event.
    ///   - end: the end time of the event.
    ///   - location: the location where the event takes place.
    ///   - course: the course of which the event belongs to.
    /// - Returns: an instance of the created event.
    @discardableResult func addEventToCoreData(name: String, from start: Date, to end: Date, to section: Section, color: UIColor = .secondarySystemBackground, at location: String? = nil) throws  -> Event {
        
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: start)
        let endDay = calendar.startOfDay(for: end)
        guard startDay <= endDay else {
            throw addToCoreDataError.endPreceedsStartDay
        }
        
        let newEvent = Event(entity: Event.entity(), insertInto: context)
        newEvent.name = name
        newEvent.start = start
        newEvent.end = end
        newEvent.section = section
        newEvent.color = color
        newEvent.location = location
        appDelegate.saveContext()
        return newEvent
    }
    
    /// An alternative way to add a new event to core data.
    @discardableResult func addEventToCoreData(name: String, interval: DateInterval, to section: Section, color: UIColor = .secondarySystemBackground, at location: String? = nil) throws -> Event {
        do {
            let newEvent = try addEventToCoreData(name: name, from: interval.start, to: interval.end, to: section, color: color, at: location)
            return newEvent
        } catch {
            throw error
        }
    }
    
}

// Debug functions

extension CoreDataController {
    
    func addTestDataToCoreData() {
        
        let calendar = Calendar.current
        let startTime = calendar.startOfDay(for: Date())
        let endTime = calendar.date(byAdding: DateComponents(day: 14), to: startTime)!
        let cse131 = addCourseToCoreData(name: "Introduction to Computer Science", id: "131", to: testDepartment, to: testSession)
        do {
            try addSectionToCoreData(id: "11", start: calendar.date(byAdding: DateComponents(hour: 11, minute: 30), to: startTime)!, end: calendar.date(byAdding: DateComponents(hour: 12, minute: 50), to: endTime)!, repeat: "-T-R---", to: cse131, color: .systemRed, at: "Urbauer / 222")
            try addSectionToCoreData(id: "22", start: calendar.date(byAdding: DateComponents(hour: 13, minute: 00), to: startTime)!, end: calendar.date(byAdding: DateComponents(hour: 14, minute: 20), to: endTime)!, repeat: "-T-R---", to: cse131, color: .systemPink, at: "Urbauer / 218")
            try addSectionToCoreData(id: "33", start: calendar.date(byAdding: DateComponents(hour: 14, minute: 30), to: startTime)!, end: calendar.date(byAdding: DateComponents(hour: 15, minute: 50), to: endTime)!, repeat: "M-W----", to: cse131, color: .systemIndigo, at: "Urbauer / 216")
            try addSectionToCoreData(id: "44", start: calendar.date(byAdding: DateComponents(hour: 16, minute: 00), to: startTime)!, end: calendar.date(byAdding: DateComponents(hour: 17, minute: 20), to: endTime)!, repeat: "M-W----", to: cse131, color: .systemPurple, at: "Urbauer / 214")
        } catch {
            print(error)
        }
        
    }
    
}
