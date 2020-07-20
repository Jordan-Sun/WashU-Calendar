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
    /// Core data controller
    private var coreDataController: CoreDataController!
    /// Core data fetched result controller
    private var eventFetchedResultController: NSFetchedResultsController<Event>!
    
    var courseName: String!
    var startTime: Date!
    var endTime: Date!
    
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
        
        let school = coreDataController.addSchoolToCoreData(fullName: "Engineering")
        let department = coreDataController.addDepartmentToCoreData(fullName: "Computer Science and Engineering", code: "E81", to: school)
        let semester = coreDataController.addSemesterToCoreData(name: "20FL")
        let session = coreDataController.addSessionToCoreData(name: "All", semester: semester)
        let course = coreDataController.addCourseToCoreData(name: courseName, id: "", department: department, session: session)
        let start = stringOfDate(startTime)
        let end = stringOfDate(endTime)
        coreDataController.addEventToCoreData(name: courseName, from: startTime, to: endTime, to: course)
        
        print("saved! " + courseName + " from: " + start + " to: " + end)
        
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
