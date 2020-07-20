//
//  ViewController.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/17.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit
import CoreData
import FSCalendar



class ViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate {
    
    // Core Data Component
    /// App delegate
    private var appDelegate = UIApplication.shared.delegate as!  AppDelegate
    /// Core data context
    private var context = (UIApplication.shared.delegate as!  AppDelegate).persistentContainer.viewContext
    /// Core data controller
    private var coreDataController: CoreDataController!
    /// Core data fetched result controller
    private var eventFetchedResultController: NSFetchedResultsController<Event>!
    
    @IBOutlet weak var theCalendar: FSCalendar!
    
    @IBOutlet weak var theTitle: UINavigationItem!
    
    @IBOutlet weak var theTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        theCalendar.delegate = self
        setUpCalendar()
        setUpTableView()
        
    }
    
    /// use FSCalendar
    func setUpCalendar() {
        theCalendar.delegate = self
        theCalendar.dataSource = self
        theCalendar.register(FSCalendarCell.self, forCellReuseIdentifier: "cell")
        theCalendar.scrollDirection = .vertical
        theCalendar.adjustMonthPosition()
        
    }
    
    /// display schdule list of slected date in theTableView
    func setUpTableView() {

    }
    

    /// back to page of currentday
    @IBAction func backToToday(_ sender: Any) {
        let currentDate = Date()
        theCalendar.setCurrentPage(currentDate, animated: true)  
        updateTableView(currentDate)
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        
        return cell
    }
    
    /// display date: Example: Jul 17, 2020
    func stringOfDate(_ date: Date) -> String {
//        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    /// display time: Example: 1:30 AM
    func stringOfTime(_ date:Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        let timeString = formatter.string(from: date)
        return timeString
        
    }
    
    /// when date is selected in the calendar
    /// table view will display the schdule of selected date
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        updateTableView(date)
        
        print(date)
    }
    
    func updateTableView(_ date: Date) {
//        func (day: Date) -> [Event] {} will be used here
//        let events = eventFetchedResultController.fetchedObjects!
//        for event in events {
//            let startTime = stringOfTime(event.start!)
//            print(startTime)
//            let endTime = stringOfTime(event.end!)
//            print(endTime)
//        }
    }
    
    
    
    
}
