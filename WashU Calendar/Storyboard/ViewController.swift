//
//  ViewController.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/17.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var appDelegate = UIApplication.shared.delegate as!  AppDelegate
    private var context = (UIApplication.shared.delegate as!  AppDelegate).persistentContainer.viewContext
    
    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load course data after the view appears.
        do {
            courses = try context.fetch(Course.fetchRequest())
            for course in courses {
                print(course.name ?? "nil")
            }
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    /// Add a new course to core data.
    /// - Parameters:
    ///   - name: the name of the course. (required)
    ///   - id: the id of the course. (required)
    ///   - events: an array of events consists of lectures, exams and other events of the course. (required)
    ///   - professor: the professor who teaches the course
    ///   - department: the department of which the course belongs to.
    ///   - session: the session of which the course belongs to.
    ///   - attributes: an array of attributes that the course conforms to.
    func addCourseToCoreData(name: String, id: String, with events: [Event] = [Event](), professor: String? = nil, department: Department? = nil, session: Session? = nil, attributes: [Attribute] = [Attribute]()) {
        let newCourse = Course(entity: Course.entity(), insertInto: context)
        newCourse.name = name
        newCourse.id = id
        newCourse.professor = professor
        newCourse.department = department
        newCourse.session = session
        newCourse.addToEvents(NSSet(array: events))
        newCourse.addToAttributes(NSSet(array: attributes))
        appDelegate.saveContext()
    }
    
    /// Add a new event to core data.
    /// - Parameters:
    ///   - start: the start time of the event.
    ///   - end: the end time of the event.
    ///   - location: the location where the event takes place.
    ///   - course: the course of which the event belongs to.
    func addEventToCoreData(from start: Date, to end: Date, at location: String? = nil, to course: Course? = nil) {
        let newEvent = Event(entity: Event.entity(), insertInto: context)
        newEvent.start = start
        newEvent.end = end
        newEvent.location = location
        newEvent.course = course
        appDelegate.saveContext()
    }
    
    /// An alternative way to add a new event to core data.
    func addEventToCoreData(interval: DateInterval, at location: String? = nil, to course: Course? = nil) {
        let newEvent = Event(entity: Event.entity(), insertInto: context)
        newEvent.start = interval.start
        newEvent.end = interval.end
        newEvent.location = location
        newEvent.course = course
        appDelegate.saveContext()
    }
    
    //Debug functions
    
    @IBAction func addRandomCourse(_ sender: Any) {
        addCourseToCoreData(name: "Test Course", id: "000")
    }
    
}

