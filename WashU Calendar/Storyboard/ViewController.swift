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
    }
    
    /// Add a new course to core data
    /// - Parameters:
    ///   - name: the name of the course
    ///   - id: the id of the course
    ///   - events: an array of events consists of lectures, exams and other events of the course.
    ///   - professor: the professor who teaches the course
    ///   - department: the department of which the course belongs to.
    ///   - session: the session of which the course belongs to.
    func addCourseToCoreData(name: String, id: String, events: [Event], professor: String? = nil, department: Department? = nil, session: Session? = nil, attributes: [Attribute] = [Attribute]()) {
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
    
}

