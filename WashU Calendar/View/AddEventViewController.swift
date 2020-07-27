//
//  AddEventViewController.swift
//  WashU Calendar
//
//  Created by Coco Zhu on 7/25/20.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UITextFieldDelegate {
    
    private var appDelegate = UIApplication.shared.delegate as!  AppDelegate
    /// Core data context
    private var context = (UIApplication.shared.delegate as!  AppDelegate).persistentContainer.viewContext
    /// Core data controller
    private var coreDataController: CoreDataController!
    
    /// Record of user input
    var eventName = ""
    var startTime = Date()
    var endTime = Date()
    var loc: String?
    var color = UIColor.systemOrange
    var section: Section?
    var repeatString = "-------"
    
    @IBOutlet weak var eventTextField: UITextField!
    
    @IBOutlet weak var startTimeTextField: UITextField!
    
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    @IBOutlet weak var locTextField: UITextField!
    
    @IBOutlet weak var colorLabel: UILabel!
    
    @IBOutlet weak var colorSelectedButton: UIButton!
    
    @IBOutlet weak var colorCollection: UIStackView!
    
    @IBOutlet weak var repeatSwitch: UISwitch!
    
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var sundayButton: UIButton!
    
    @IBOutlet weak var dayOfWeekCollection: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        coreDataController = CoreDataController(appDelegate: appDelegate, context: context)
        
        self.colorCollection.isHidden = true
        self.dayOfWeekCollection.isHidden = true
        
        startTimePicker.addTarget(self, action: #selector(AddEventViewController.startTimePickerValueChanged(sender:)), for: .valueChanged)

        
        endTimePicker.addTarget(self, action: #selector(AddEventViewController.endTimePickerValueChanged(sender:)), for: .valueChanged)
        
        /// tapping outside the date picker leads to hide it
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddEventViewController.dismissDatePicker))
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
       
    @IBAction func eventBeginEditing(_ sender: UITextField) {
        startTimePicker.isHidden = true
        endTimePicker.isHidden = true
    }
    
    /// update course name to whatever user input
    @IBAction func eventCompleted(_ sender: UITextField) {
        eventName = eventTextField.text!
    }
    @IBAction func locationBeginEditing(_ sender: UITextField) {
        startTimePicker.isHidden = true
        endTimePicker.isHidden = true
    }
    
    @IBAction func locationCompleted(_ sender: UITextField) {
        loc = locTextField.text!
    }
    
    
    @IBAction func startTimeBeginEditing(_ sender: UITextField) {
        self.startTimePicker.isHidden = false
        self.endTimePicker.isHidden = true
        if startTimeTextField.hasText {
            startTimePicker.date = startTime
            startTimeTextField.text = stringOfDateAndTime(startTime)
        } else {
            startTimeTextField.text = stringOfDateAndTime(Date())
        }
        if endTimeTextField.hasText {
            startTimePicker.maximumDate = endTimePicker.date
        }
        self.view.endEditing(true)
    }
    
       
    @IBAction func endTimeBeginEditing(_ sender: Any) {
        self.endTimePicker.isHidden = false
        self.startTimePicker.isHidden = true
        if startTimeTextField.hasText {
            endTimePicker.minimumDate = startTimePicker.date
        }
        if endTimeTextField.hasText {
            endTimePicker.date = endTime
            endTimeTextField.text = stringOfDateAndTime(endTime)
        } else {
            endTimeTextField.text = stringOfDateAndTime(Date())
        }
        self.view.endEditing(true)
    }
    
    @IBAction func selectColor(_ sender: Any) {
        if self.colorCollection.isHidden == false {
            self.colorCollection.isHidden = true
        } else {
            self.colorCollection.isHidden = false
        }
        startTimePicker.isHidden = true
        endTimePicker.isHidden = true
        self.view.endEditing(true)
    }
    
    
    @IBAction func colorSelected(_ sender: UIButton) {
        colorSelectedButton.tintColor = sender.tintColor
        color = sender.tintColor
        
    }
    
    @IBAction func repeatSwitched(_ sender: UISwitch) {
        if sender.isOn {
            self.dayOfWeekCollection.isHidden = false
        } else {
            self.dayOfWeekCollection.isHidden = true
            repeatString = "-------"
        }
        startTimePicker.isHidden = true
        endTimePicker.isHidden = true
        self.view.endEditing(true)
    }
    
    @IBAction func dayOfWeekSelected(_ sender: UIButton) {
        if sender.tintColor == UIColor.systemGray3 {
            sender.tintColor = UIColor.systemBlue
            if sender == mondayButton {
                repeatString = replace(repeatString, at: 0, with: "M")
            } else if sender == tuesdayButton {
                repeatString = replace(repeatString, at: 1, with: "T")
            } else if sender == wednesdayButton {
                repeatString = replace(repeatString, at: 2, with: "W")
            } else if sender == thursdayButton {
                repeatString = replace(repeatString, at: 3, with: "R")
            } else if sender == fridayButton {
                repeatString = replace(repeatString, at: 4, with: "F")
            } else if sender == saturdayButton {
                repeatString = replace(repeatString, at: 5, with: "S")
            } else if sender == sundayButton {
                repeatString = replace(repeatString, at: 6, with: "U")
            }
        } else {
            sender.tintColor = UIColor.systemGray3
            if sender == mondayButton {
                repeatString = replace(repeatString, at: 0, with: "-")
            } else if sender == tuesdayButton {
                repeatString = replace(repeatString, at: 1, with: "-")
            } else if sender == wednesdayButton {
                repeatString = replace(repeatString, at: 2, with: "-")
            } else if sender == thursdayButton {
                repeatString = replace(repeatString, at: 3, with: "-")
            } else if sender == fridayButton {
                repeatString = replace(repeatString, at: 4, with: "-")
            } else if sender == saturdayButton {
                repeatString = replace(repeatString, at: 5, with: "-")
            } else if sender == sundayButton {
                repeatString = replace(repeatString, at: 6, with: "-")
            }
        }
        
        print(repeatString)
    }
    
    func replace(_ myString: String, at index: Int, with newChar: Character) -> String {
        var chars = Array(myString)
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }

    
    @IBAction func saveEventToCalendar(_ sender: Any) {
        if eventName == "" || startTimeTextField.hasText == false || endTimeTextField.hasText == false{
            let alert = UIAlertController(title: "Can't Add Event", message: "Please enter a valid title/start time/end time!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            do {
                section = try coreDataController.addSectionToCoreData(id: eventName, start: startTime, end: endTime, repeat: repeatString)
                
                try coreDataController.addEventToCoreData(name: eventName, from: startTime, to: endTime, to: section, color: color, at: loc)
            } catch {
                print(error)
            }

            print("saved!")
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func cancelAdding(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissDatePicker() {
        startTimePicker.isHidden = true
        endTimePicker.isHidden = true
        colorCollection.isHidden = true
        self.view.endEditing(true)
    }
    
    /// display date and time: Example: 07/17/2020 at 3:40 AM
    func stringOfDateAndTime(_ date: Date) -> String {
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


