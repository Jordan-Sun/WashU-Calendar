//
//  AddEventViewController.swift
//  WashU Calendar
//
//  Created by Coco Zhu on 7/25/20.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UITextFieldDelegate {
    
    /// Core data controller
    var coreDataController: CoreDataController!
    
    /// Record of user input
    var eventName = ""
    var currentTime = Date()
    var startTime: Date!
    var endTime: Date!
    var repeatEndDate = Date()
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
    
    @IBOutlet weak var repeatEndDateTextField: UITextField!
    
    @IBOutlet weak var repeatEndDateTimePicker: UIDatePicker!
    
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
        
        startTime = generateStartTime()
        endTime = Date(timeInterval: 3600, since: startTime)
        
        startTimePicker.addTarget(self, action: #selector(AddEventViewController.startTimePickerValueChanged(sender:)), for: .valueChanged)

        endTimePicker.addTarget(self, action: #selector(AddEventViewController.endTimePickerValueChanged(sender:)), for: .valueChanged)
        
        repeatEndDateTimePicker.addTarget(self, action: #selector(AddEventViewController.repeatEndDateTimePickerValueChanged(sender:)), for: .valueChanged)
        
        /// tapping outside the date picker leads to hide it
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddEventViewController.dismissDatePicker))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func startTimePickerValueChanged(sender: UIDatePicker) {
        startTime = startTimePicker.date
        startTimeTextField.text = stringOfDateAndTime(startTime)
        if startTime > endTime {
            endTime = startTime
        }
        else if stringOfDate(startTime) != stringOfDate(endTime) {
            endTime = generateRepeatEndDateAndTime(time: endTime, date: startTime)
        }
        endTimeTextField.text = stringOfDateAndTime(endTime)
    }
       
    @objc func endTimePickerValueChanged(sender: UIDatePicker) {
        endTime = endTimePicker.date
        endTimeTextField.text = stringOfDateAndTime(endTime)
    }
    
    @objc func repeatEndDateTimePickerValueChanged(sender: UIDatePicker) {
        repeatEndDate = repeatEndDateTimePicker.date
        repeatEndDateTextField.text = stringOfDate(repeatEndDate)
    }
       
    @IBAction func eventBeginEditing(_ sender: UITextField) {
        startTimePicker.isHidden = true
        endTimePicker.isHidden = true
        repeatEndDateTimePicker.isHidden = true
    }
    
    /// update course name to whatever user input
    @IBAction func eventCompleted(_ sender: UITextField) {
        eventName = eventTextField.text!
    }
    @IBAction func locationBeginEditing(_ sender: UITextField) {
        startTimePicker.isHidden = true
        endTimePicker.isHidden = true
        repeatEndDateTimePicker.isHidden = true
    }
    
    @IBAction func locationCompleted(_ sender: UITextField) {
        loc = locTextField.text!
    }
    
    @IBAction func startTimeBeginEditing(_ sender: UITextField) {
        self.startTimePicker.isHidden = false
        self.endTimePicker.isHidden = true
        self.repeatEndDateTimePicker.isHidden = true
        startTimePicker.date = startTime
        startTimeTextField.text = stringOfDateAndTime(startTime)
        self.view.endEditing(true)
    }
       
    @IBAction func endTimeBeginEditing(_ sender: Any) {
        self.endTimePicker.isHidden = false
        self.startTimePicker.isHidden = true
        self.repeatEndDateTimePicker.isHidden = true
        /// set end time no earlier than start time
        if startTimeTextField.hasText {
            // set up min and max time of date picker
            endTimePicker.minimumDate = startTimePicker.date
            let dateString = stringOfDate(startTime)
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY/MM/dd HH:mm"
            let maxEndTime = formatter.date(from: "\(dateString) 23:55")!
            endTimePicker.maximumDate = maxEndTime
            if startTime > endTime {
                endTime = startTime
            }
            if maxEndTime < endTime {
                endTime = maxEndTime
            }
            endTimePicker.date = endTime
        }
        if endTimeTextField.hasText {
            endTimePicker.date = endTime
        }
        endTimeTextField.text = stringOfDateAndTime(endTime)
        self.view.endEditing(true)
    }
    
    @IBAction func repeatEndDateBeginEditing(_ sender: UITextField) {
        self.repeatEndDateTimePicker.isHidden = false
        repeatEndDateTimePicker.minimumDate = startTime
        repeatEndDateTimePicker.date = repeatEndDate
        repeatEndDateTextField.text = stringOfDate(repeatEndDate)
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
        repeatEndDateTimePicker.isHidden = true
        self.view.endEditing(true)
    }
    
    
    @IBAction func colorSelected(_ sender: UIButton) {
        colorSelectedButton.tintColor = sender.tintColor
        color = sender.tintColor
        
    }
    
    @IBAction func repeatSwitched(_ sender: UISwitch) {
        if sender.isOn {
            self.dayOfWeekCollection.isHidden = false
            self.repeatEndDateTextField.isHidden = false
        } else {
            self.dayOfWeekCollection.isHidden = true
            self.repeatEndDateTextField.isHidden = true
            self.repeatEndDateTimePicker.isHidden = true
        }
        startTimePicker.isHidden = true
        endTimePicker.isHidden = true
        self.view.endEditing(true)
    }
    
    @IBAction func dayOfWeekSelected(_ sender: UIButton) {
        repeatEndDateTimePicker.isHidden = true
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
                repeatString = replace(repeatString, at: 6, with: "S")
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
    }
    
    func replace(_ myString: String, at index: Int, with newChar: Character) -> String {
        var chars = Array(myString)
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }

    
    @IBAction func saveEventToCalendar(_ sender: Any) {
        if eventName == "" {
            let alert = UIAlertController(title: "Please enter a valid title!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if startTimeTextField.hasText == false {
            let alert = UIAlertController(title: "Please enter a valid start time!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if endTimeTextField.hasText == false {
            let alert = UIAlertController(title: "Please enter a valid end time!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if startTime > endTime {
            let alert = UIAlertController(title: "Start time cannot be later than end time!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if stringOfDate(startTime) != stringOfDate(endTime){
            let alert = UIAlertController(title: "Start time and end time should be on the same date.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            /// repeat event
            if repeatSwitch.isOn {
                if repeatEndDateTextField.hasText == false {
                    let alert = UIAlertController(title: "Repeat end date can not be empty!", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    do {
                        let endDateAndTime = generateRepeatEndDateAndTime(time: endTime, date: repeatEndDate
                        )
                        try coreDataController.addSectionToCoreData(id: eventName, start: startTime, end: endDateAndTime, repeat: repeatString, color: color)
                    } catch {
                        switch error {
                        case CoreDataController.AddToCoreDataError.endPreceedsStartDay:
                            //Do sth.
                            print()
                        case CoreDataController.AddToCoreDataError.endPreceedsStartTime:
                            //Do sth.
                            print()
                        default:
                            print("Uncaught exception: \(error)")
                        }
                        print(error)
                    }
                    dismiss(animated: true, completion: nil)
                }
            }
            /// one-time event
            else {
                do {
                    try coreDataController.addEventToCoreData(name: eventName, from: startTime, to: endTime, to: nil, color: color, at: loc)
                } catch {
                    switch error {
                    case CoreDataController.AddToCoreDataError.endPreceedsStartDay:
                        //Do sth.
                        print()
                    case CoreDataController.AddToCoreDataError.endPreceedsStartTime:
                        //Do sth.
                        print()
                    default:
                        print("Uncaught exception: \(error)")
                    }
                    print(error)
                }
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func cancelAdding(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Are you sure you want to discard this new event?", message: .none, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Keep Editing", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Discard Changes", style: .destructive, handler: { action in self.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissDatePicker() {
        startTimePicker.isHidden = true
        endTimePicker.isHidden = true
        repeatEndDateTimePicker.isHidden = true
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
    
    ///
    func generateRepeatEndDateAndTime(time: Date, date: Date) -> Date {
        let dateString = stringOfDate(date)
        let hour = NSCalendar.current.component(.hour, from: time)
        let minutes = NSCalendar.current.component(.minute, from: time)
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm"
        let endDateTime = formatter.date(from: "\(dateString) \(hour):\(minutes)")!
        return endDateTime
    }
    
    func generateStartTime() -> Date {
        let dateString = stringOfDate(Date())
        let hour = NSCalendar.current.component(.hour, from: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm"
        let startDateTime = formatter.date(from: "\(dateString) \(hour):00")!
        return startDateTime
    }

    
    func stringOfDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "YYYY/MM/dd"
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


