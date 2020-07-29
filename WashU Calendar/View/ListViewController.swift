//
//  ListViewController.swift
//  WashU Calendar
//
//  Created by Coco Zhu on 2020/7/17.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController {
    
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
    private var eventCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Date,Event>!
    /// The min section
    private var minDateFromNow = -3
    /// The max section
    private var maxDateFromNow = 14
    /// A boolean indicating whether the collection view should preload cell
    private var shouldPreloadCell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        coreDataController = CoreDataController(appDelegate: appDelegate, context: context)
        coreDataController.delegate = self
        
        configureCollectionDataSource()
        configureCollectionLayout()
//        configureGestureRecognizers()
        eventCollectionView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load course data after the view appears.
        updateSnapshot()
        eventCollectionView.scrollToItem(at: IndexPath(row: 0, section: -minDateFromNow), at: .top, animated: false)
    }
    
    
    @IBAction func pushAddView(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Add a new event ...", message: nil, preferredStyle: .actionSheet)
        
        let manualAction = UIAlertAction(title: "Manually", style: .default, handler: {
            action in
            let newViewController = AddEventViewController()
            newViewController.coreDataController = self.coreDataController
            self.present(newViewController, animated: true, completion: nil)
        })
        actionSheet.addAction(manualAction)
        
        let courseListingAction = UIAlertAction(title: "via CourseListing", style: .default, handler: {
            action in
            let newViewController = AddCourseListingViewController()
            newViewController.coreDataController = self.coreDataController
            self.present(newViewController, animated: true, completion: nil)
        })
        actionSheet.addAction(courseListingAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
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
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: groupColumns)
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(44)), elementKind: "dayHeader", alignment: .top)
            header.pinToVisibleBounds = true
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
            
            guard event.end != nil else {
                
                // Provide exception cell
                cell.nameLabel.text = event.name
                cell.nameLabel.textColor = .systemGray
                cell.nameLabel.textAlignment = .center
                cell.locationLabel.text = nil
                cell.timeLabel.text = nil
                cell.backgroundColor = .systemBackground
                
                // Preload sections
                //self.preloadSection(indexPath.section)
                
                return cell
            }
            
            // Update cell
            cell.nameLabel.text = event.name
            cell.nameLabel.textColor = .label
            cell.nameLabel.textAlignment = .natural
            cell.locationLabel.text = event.location ?? "TBA"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            cell.timeLabel.text = "\(dateFormatter.string(from: event.start!))-\(dateFormatter.string(from: event.end!))"
            cell.layer.cornerRadius = 8
            cell.backgroundColor = (event.color as? UIColor) ?? .secondarySystemBackground
            
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
        header.backgroundColor = .systemBackground
        
        // Get genre section at the target index path
        let calendar = Calendar.current
        guard let then = eventCollectionViewDiffableDataSource.itemIdentifier(for: indexPath)?.start else {
            print("Fail to retrive day from \(indexPath).")
            return nil
        }
        let daysFromNow = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: then) ).day!
        
        // Configure header
        switch daysFromNow {
        case -1:
            header.label.text = "Yesterday"
        case 0:
            header.label.text = "Today"
        case 1:
            header.label.text = "Tomorrow"
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd, EEEE")
            header.label.text = dateFormatter.string(from: then)
        }
        
        return header
        
    }
    
    /// Fetch events from a given date and append it to a snapshot.
    /// - Parameters:
    ///   - snapshot: The snapshot to append events to.
    ///   - date: A date that indicates the day that fetched events should take place on.
    fileprivate func appendDateToSnapshot(_ snapshot: inout NSDiffableDataSourceSnapshot<Date, Event>, _ date: Date) {
        snapshot.appendSections([date])
        if let events = coreDataController.fetchEventRequest(on: date) {
            if events.isEmpty {
                let nilEvent = Event(entity: Event.entity(), insertInto: nil)
                nilEvent.name = "Nothing planned today"
                nilEvent.start = date
                snapshot.appendItems([nilEvent], toSection: date)
            } else {
                snapshot.appendItems(events, toSection: date)
            }
        } else {
            let failEvent = Event(entity: Event.entity(), insertInto: nil)
            failEvent.name = "Fail to fetch event data"
            failEvent.start = date
            snapshot.appendItems([failEvent], toSection: date)
        }
    }
    
    /// Initialize the snapshot using NSFetchRequest
    private func updateSnapshot() {
        
        shouldPreloadCell = false
        
        // Initialize a new snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Date,Event>()
        
        // Fetch this week's event
        let calendar = Calendar.current
        let now = appDelegate.currentDate
        
        for daysFromNow in minDateFromNow ... maxDateFromNow {
            guard let then = calendar.date(byAdding: DateComponents(day: daysFromNow), to: now) else {
                print("Fail to compute the date \(daysFromNow) days from now.")
                return
            }
            appendDateToSnapshot(&snapshot, then)
        }
        let newSnapshot = snapshot
        
        // Apply snapshot
        eventCollectionViewDiffableDataSource.apply(newSnapshot)
        
        shouldPreloadCell = true
        
    }
    
}

extension ListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if shouldPreloadCell {
            // Check if should preload the next section.
            if indexPath.section + 1 > maxDateFromNow - minDateFromNow {
                maxDateFromNow += 1
                updateSnapshot()
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailView = EventDetailViewController()
        detailView.event = eventCollectionViewDiffableDataSource.itemIdentifier(for: indexPath)
        detailView.coreDataController = coreDataController
        navigationController?.pushViewController(detailView, animated: true)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if shouldPreloadCell {
            guard let minVisibleIndexPath = eventCollectionView.indexPathsForVisibleItems.min() else {
                print("Fail to get min visible index path for event collection view.")
                return
            }
            
            if minVisibleIndexPath.section == 0 {
                minDateFromNow -= 1
                updateSnapshot()
            }
        }
        
    }
    
}

extension ListViewController: CoreDataControllerDelegate {
    
    func controllerDidChangeContent() {
        self.updateSnapshot()
    }
    
}
