//
//  ViewController.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/17.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // Core Data Component
    /// App delegate
    private var appDelegate = UIApplication.shared.delegate as!  AppDelegate
    /// Core data context
    private var context = (UIApplication.shared.delegate as!  AppDelegate).persistentContainer.viewContext
    /// Core data controller
    private var coreDataController: CoreDataController!
    /// Core data fetched result controller
    private var eventFetchedResultController: NSFetchedResultsController<Event>!
    
    // Collection View Component
    /// Collection view
    @IBOutlet weak var eventCollectionView: UICollectionView!
    /// Collection view data source
    private var eventCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Section,Event>!
    
    // Debug Component
    /// An array that temporarily stores courses
    var courses = [Course]()
    /// Main section of the collection view
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coreDataController = CoreDataController(appDelegate: appDelegate, context: context)
        configureCollectionDataSource()
        configureCollectionLayout()
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
        updateSnapshot()
    }
    
    //Debug functions
    @IBAction func addTenRandomCourse(_ sender: Any) {
        coreDataController.addTestDataToCoreData()
        updateSnapshot()
    }
    
}

// Collection View Delegate

//extension ViewController {
//
//}

// Collection View Layout

extension ViewController {
    
    /// Configure the layout of the movie preview collection view
    private func configureCollectionLayout() {
        eventCollectionView.collectionViewLayout = createLayout()
    }
    
    /// Create a new collection view compositional layout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let groupColumns = 2
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: groupColumns)
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
            
        }
        
        return layout
        
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
    
    /// Updates the snapshot using NSFetchRequest
    private func updateSnapshot() {
        
        // Fetch request
        let request = Event.fetchRequest() as NSFetchRequest<Event>
        let sort = NSSortDescriptor(key: #keyPath(Event.start), ascending: true)
        request.sortDescriptors = [sort]
        do {
            eventFetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try eventFetchedResultController.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        // Update snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section,Event>()
        if let events = eventFetchedResultController.fetchedObjects {
            snapshot.appendSections([.main])
            snapshot.appendItems(events, toSection: .main)
        }
        eventCollectionViewDiffableDataSource.apply(snapshot)
        
    }
    
}
