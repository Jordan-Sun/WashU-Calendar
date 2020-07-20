//
//  AddSthViewController.swift
//  WashU Calendar
//
//  Created by Coco Zhu on 7/18/20.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit
import CoreData

class AddSthViewController: UIViewController, UITextFieldDelegate {
    
    private var appDelegate = UIApplication.shared.delegate as!  AppDelegate
    /// Core data context
    private var context = (UIApplication.shared.delegate as!  AppDelegate).persistentContainer.viewContext
    /// Core data controller
    private var coreDataController: CoreDataController!
    /// Core data fetched result controller
    private var eventFetchedResultController: NSFetchedResultsController<Event>!
    
    /// Record of user input
    var courseName = ""
    var startTime = Date()
    var endTime = Date()
    
    @IBOutlet weak var courseTextField: UITextField!
    
    @IBOutlet weak var startTimeTextField: UITextField!
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coreDataController = CoreDataController(appDelegate: appDelegate, context: context)
        
        startTimePicker.addTarget(self, action: #selector(AddSthViewController.startTimePickerValueChanged(sender:)), for: .valueChanged)

        
        endTimePicker.addTarget(self, action: #selector(AddSthViewController.endTimePickerValueChanged(sender:)), for: .valueChanged)
        
        /// tapping outside the date picker leads to hide it
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddSthViewController.dismissDatePicker))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func startTimePickerValueChanged(sender: UIDatePicker) {
        startTime = startTimePicker.date
        startTimeTextField.text = stringOfDateAndTime(startTime)
    }
    
    @objc func endTimePickerValueChanged(sender: UIDatePicker) {
        endTime = endTimePicker.date
        endTimeTextField.text = stringOfDateAndTime(endTime)
    }
    
    
    /// update course name to whatever user input
    @IBAction func courseCompleted(_ sender: Any) {
        courseName = courseTextField.text!
    }
    

    
    @IBAction func startTimeBeginEditing(_ sender: UITextField) {
        self.startTimePicker.isHidden = false
        self.endTimePicker.isHidden = true
        startTimeTextField.text = stringOfDateAndTime(Date())
        if endTimeTextField.hasText {
            startTimePicker.maximumDate = endTimePicker.date
        }
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func endTimeBeginEditing(_ sender: UITextField) {
        self.endTimePicker.isHidden = false
        self.startTimePicker.isHidden = true
        endTimeTextField.text = stringOfDateAndTime(Date())
        if startTimeTextField.hasText {
            endTimePicker.minimumDate = startTimePicker.date
        }
        self.view.endEditing(true)
    }
    
    
    
    /// save the event to core data
    @IBAction func saveEventToCalendar(_ sender: Any) {
        if courseName == "" || startTimeTextField.hasText == false || endTimeTextField.hasText == false{
            let alert = UIAlertController(title: "Can't Add Event", message: "Please enter a valid course name!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let school = coreDataController.addSchoolToCoreData(fullName: "Engineering")
            let department = coreDataController.addDepartmentToCoreData(fullName: "Computer Science and Engineering", code: "E81", to: school)
            let semester = coreDataController.addSemesterToCoreData(name: "20FL")
            let session = coreDataController.addSessionToCoreData(name: "All", semester: semester)
            let course = coreDataController.addCourseToCoreData(name: courseName, id: "", department: department, session: session)
            let start = stringOfDateAndTime(startTime)
            let end = stringOfDateAndTime(endTime)
            coreDataController?.addEventToCoreData(name: courseName, from: startTime, to: endTime, to: course)

            print("saved! " + courseName + " from: " + start + " to: " + end)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    /// back to home view
    @IBAction func cancelAdding(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func dismissDatePicker() {
        startTimePicker.isHidden = true
        endTimePicker.isHidden = true
        
    }
    
    
    /// display date and time: Example: 07/17/2020 at 3:40 AM
    func stringOfDateAndTime(_ date: Date) -> String {
    //        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let dateString = formatter.string(from: date)
        return dateString
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
