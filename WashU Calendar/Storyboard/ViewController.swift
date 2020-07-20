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
    
    // Json Component
    /// Json controller
    private var jsonController: JsonController!
    
    @IBOutlet weak var theCalendar: FSCalendar!
    
    @IBOutlet weak var theTitle: UINavigationItem!
    
    @IBOutlet weak var theTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        coreDataController = CoreDataController(appDelegate: appDelegate, context: context)
        jsonController = JsonController()
        
        theCalendar.delegate = self
//        displayCurrentDate()
        setUpCalendar()
        setUpTableView()
        
        jsonController.generateTestData()
        
    }

    func setUpCalendar() {
        theCalendar.delegate = self
        theCalendar.dataSource = self
        theCalendar.register(FSCalendarCell.self, forCellReuseIdentifier: "cell")
        theCalendar.scrollDirection = .vertical
        theCalendar.adjustMonthPosition()
        
    }
    
    func setUpTableView() {
        
    }
    
    //Debug functions
    
    @IBAction func backToToday(_ sender: Any) {
        
//
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        
        return cell
    }
    
    func stringOfDate(_ date: Date) -> String {
//        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: date)
        return dateString
//        theTitle.title = dateString
    }
    
//    display schdule of selected date in the table view
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    
    
}
