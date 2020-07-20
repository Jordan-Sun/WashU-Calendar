//
//  ListViewController.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/17.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    // Core Data Component
    /// App delegate
    private var appDelegate = UIApplication.shared.delegate as!  AppDelegate
    /// Core data context
    private var context = (UIApplication.shared.delegate as!  AppDelegate).persistentContainer.viewContext
    /// Core data controller
    private var coreDataController: CoreDataController!
    
    // Collection View Component
    /// Collection view
    @IBOutlet weak var eventCollectionView: UICollectionView!
    /// Collection view data source
    private var eventCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Date,Event>!
    
    // Debug Component
    /// An array that temporarily stores courses
    var courses = [Course]()
    
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

// Collection View Layout

extension ListViewController {
    
    /// Configure the layout of the movie preview collection view
    private func configureCollectionLayout() {
        eventCollectionView.collectionViewLayout = createLayout()
        eventCollectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: "dayHeader", withReuseIdentifier: HeaderCollectionReusableView.reuseIdentifier)
    }
    
    /// Create a new collection view compositional layout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            
            let groupColumns = 1
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: groupColumns)
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(44)), elementKind: "dayHeader", alignment: .top)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            
            return section
            
        }
        
        return layout
        
    }
    
}

// Collection View Data Source

extension ListViewController {
    
    /// Configure the datasource of the movie preview collection view
    private func configureCollectionDataSource() {
        
        // Diffable data source cell provider
        eventCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Date,Event>(collectionView: self.eventCollectionView) { (collectionView, indexPath, event) -> UICollectionViewCell? in
            
            // Dequeue reuseable cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCollectionViewCell.reuseIdentifier, for: indexPath) as? EventCollectionViewCell else {
                fatalError("Expected reused cell to be of type EventCollectionViewCell.")
            }
            
            // Update cell
            cell.nameLabel.text = event.name
            cell.locationLabel.text = event.location
            cell.backgroundColor = UIColor.secondarySystemBackground
            
            return cell
            
        }
        
        // Diffable data source supplementary view provider
        eventCollectionViewDiffableDataSource.supplementaryViewProvider = {
            (collectionView, kind, indexPath) -> UICollectionReusableView? in
            
            // Check is proving a rating badge supplementary view
            switch kind {
            case "dayHeader":
                return self.createHeader(collectionView: collectionView, indexPath: indexPath)
            default:
                return nil
            }
            
        }
        
    }
    
    private func createHeader(collectionView: UICollectionView, indexPath: IndexPath) -> HeaderCollectionReusableView? {
        
        // Dequeue reuseable supplementary view
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: "dayHeader", withReuseIdentifier: HeaderCollectionReusableView.reuseIdentifier, for: indexPath) as? HeaderCollectionReusableView else {
            fatalError("Expected reused badge to be of type HeaderCollectionReusableView.")
        }
        
        // Get genre section at the target index path
        let daysFromNow = indexPath.section
        
        // Configure header
        switch daysFromNow {
        case 0:
            header.label.text = "Today"
        case 1:
            header.label.text = "Tomorrow"
        default:
            header.label.text = "\(daysFromNow) Days From Today"
        }
        
        return header
        
    }
    
    /// Updates the snapshot using NSFetchRequest
    private func updateSnapshot() {
        
        // Update snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Date,Event>()
        let calendar = Calendar.current
        let now = Date()
        for daysFromNow in 0 ..< 14 {
            guard let then = calendar.date(byAdding: DateComponents(day: daysFromNow), to: now) else {
                print("Fail to compute the date \(daysFromNow) days from now.")
                return
            }
            snapshot.appendSections([then])
            if let events = coreDataController.fetchEventRequest(on: then) {
                snapshot.appendItems(events, toSection: then)
            }
        }
        eventCollectionViewDiffableDataSource.apply(snapshot)
        
    }
    
}
