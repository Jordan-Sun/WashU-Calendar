//
//  AddSthViewController.swift
//  WashU Calendar
//
//  Created by Coco Zhu on 7/18/20.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit
import CoreData

class AddSthViewController: UIViewController,  UITextFieldDelegate {
    
    private var appDelegate = UIApplication.shared.delegate as!  AppDelegate
    /// Core data context
    private var context = (UIApplication.shared.delegate as!  AppDelegate).persistentContainer.viewContext
    /// Core data fetched result controller
    private var eventFetchedResultController: NSFetchedResultsController<Event>!
    
    
    var courseName: String!
    var startTime: Date!
    var endTime: Date!
    
    

    var courses = [Course]()
    var school: School!
    var department: Department!
    var semester: Semester!
    var session: Session!
    
    
    @IBOutlet weak var courseTextField: UITextField!
    
    @IBOutlet weak var startTimeTextField: UITextField!
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startTimePicker.addTarget(self, action: #selector(AddSthViewController.startTimePickerValueChanged(sender:)), for: .valueChanged)

        
        endTimePicker.addTarget(self, action: #selector(AddSthViewController.endTimePickerValueChanged(sender:)), for: .valueChanged)
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddSthViewController.dismissDatePicker))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        
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
    
    
    @objc func startTimePickerValueChanged(sender: UIDatePicker) {
        startTime = startTimePicker.date
        startTimeTextField.text = stringOfDate(startTime)
    }
    
    @objc func endTimePickerValueChanged(sender: UIDatePicker) {
        endTime = endTimePicker.date
        endTimeTextField.text = stringOfDate(endTime)
    }
    
    
    
    @IBAction func courseCompleted(_ sender: Any) {
        courseName = courseTextField.text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    @IBAction func startTimeBeginEditing(_ sender: UITextField) {
        self.startTimePicker.isHidden = false
        self.endTimePicker.isHidden = true
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func endTimeBeginEditing(_ sender: UITextField) {
        self.endTimePicker.isHidden = false
        self.startTimePicker.isHidden = true
        self.view.endEditing(true)
    }
    
    
    @IBAction func addCourseToCalendar(_ sender: Any) {
        school = addSchoolToCoreData(fullName: "Engineering")
        department = addDepartmentToCoreData(fullName: "Computer Science and Engineering", code: "E81", to: school)
        semester = addSemesterToCoreData(name: "20FL")
        session = addSessionToCoreData(name: "All", semester: semester)

        let start = stringOfDate(startTime)
        let end = stringOfDate(endTime)
        print("saved! " + courseName + " from: " + start + " to: " + end)
        addCourseToCoreData(name: courseName, id: "", department: department, session: session)
        addEventToCoreData(name: courseName, from: startTime, to: endTime, to: courses[0])
        
//        let vc = storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController

    }
    
    @objc func dismissDatePicker() {
        startTimePicker.isHidden = true
        endTimePicker.isHidden = true
    }
    
    
    @objc func stringOfDate(_ date: Date) -> String {
    //        let currentDate = Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .medium
            let dateString = formatter.string(from: date)
            return dateString
    //        theTitle.title = dateString
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// Core Data Interactions

extension AddSthViewController {
    
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
