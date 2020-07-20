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
    
    // JSON Component
    /// Json controller
    private var jsonController: JsonController!
    
    // Collection View Component
    /// Collection view
    @IBOutlet weak var eventCollectionView: UICollectionView!
    /// Collection view data source
    private var eventCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Section,Event>!
    
    // Debug Component
    /// An array that temporarily stores courses
    var courses = [Course]()
  
//   ******************* Coco ******************

    
    
    @IBOutlet weak var theCalendar: FSCalendar!
    
    @IBOutlet weak var theTitle: UINavigationItem!
    
    @IBOutlet weak var theTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        theCalendar.delegate = self
//        displayCurrentDate()
        setUpCalendar()
        setUpTableView()
        coreDataController = CoreDataController(appDelegate: appDelegate, context: context)
        jsonController = JsonController()
        jsonController.generateTestData()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load course data after the view appears.
        do {
            courses = try context.fetch(Course.fetchRequest())
            for course in courses {
                print(course.id ?? "nil")
            }
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        updateSnapshot()
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
    @IBAction func addTenRandomCourse(_ sender: Any) {
        coreDataController.addTestDataToCoreData()
        updateSnapshot()
    }
    
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

// Collection View Data Source

extension ViewController: NSFetchedResultsControllerDelegate {
    
    /// Configure the datasource of the movie preview collection view
    private func configureCollectionDataSource() {
        
        // Diffable data source cell provider
        eventCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Section,Event>(collectionView: self.eventCollectionView) { (collectionView, indexPath, event) -> UICollectionViewCell? in
            
            // Dequeue reuseable cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as? EventCollectionViewCell else {
                fatalError("Expected reused cell to be of type MovieCollectionViewCell.")
            }
            
            // Update cell
            cell.nameLabel.text = event.name
            
            return cell
            
        }
        
    }
    
 //   /// Updates the snapshot using NSFetchRequest
 //   private func updateSnapshot() {
 //       
 //       // Fetch request
 //       let request = Event.fetchRequest() as NSFetchRequest<Event>
 //       let sort = NSSortDescriptor(key: #keyPath(Event.start), ascending: true)
 //       request.sortDescriptors = [sort]
 //       do {
 //           eventFetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
 //           try eventFetchedResultController.performFetch()
 //       } catch {
 //           // Replace this implementation with code to handle the error appropriately.
 //           // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
 //           let nserror = error as NSError
 //           fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
 //       }
 //       
 //       // Update snapshot
 //       var snapshot = NSDiffableDataSourceSnapshot<Section,Event>()
 //       if let events = eventFetchedResultController.fetchedObjects {
 //           snapshot.appendSections([.main])
 //           snapshot.appendItems(events, toSection: .main)
 //       }
 //       eventCollectionViewDiffableDataSource.apply(snapshot)
 //       
 //   }
    
}
