//
//  ListViewController.swift
//  WashU Calendar
//
//  Created by Coco Zhu on 2020/7/17.
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
    
    // JSON Component
    /// Json controller
    private var jsonController: JsonController!
    
    // Collection View Component
    /// Collection view
    @IBOutlet weak var eventCollectionView: UICollectionView!
    /// Collection view data source
    private var eventCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Date,Event>!
    /// The min section
    private var minDateFromNow = -3
    /// The max section
    private var maxDateFromNow = 14
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coreDataController = CoreDataController(appDelegate: appDelegate, context: context)
        jsonController = JsonController()
        configureCollectionDataSource()
        configureCollectionLayout()
//        configureGestureRecognizers()
        eventCollectionView.delegate = self
        jsonController.generateTestData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load course data after the view appears.
        updateSnapshot()
        eventCollectionView.scrollToItem(at: IndexPath(row: 0, section: -minDateFromNow - 1), at: .top, animated: false)
    }
    
    //Debug functions
    @IBAction func addTestData(_ sender: Any) {
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
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: groupColumns)
            
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
            
            guard event.start != nil else {
                
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
        
        // Get genre section at the target index path
        let daysFromNow = indexPath.section + minDateFromNow
        
        // Configure header
        switch daysFromNow {
        case 0:
            header.label.text = "Today"
        case 1:
            header.label.text = "Tomorrow"
        default:
            let calendar = Calendar.current
            let then = calendar.date(byAdding: DateComponents(day: daysFromNow), to: Date())!
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
                snapshot.appendItems([nilEvent], toSection: date)
            } else {
                snapshot.appendItems(events, toSection: date)
            }
        } else {
            let failEvent = Event(entity: Event.entity(), insertInto: nil)
            failEvent.name = "Fail to fetch event data"
            snapshot.appendItems([failEvent], toSection: date)
        }
    }
    
    /// Initialize the snapshot using NSFetchRequest
    private func updateSnapshot() {
        
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
        
    }
    
}

extension ListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Check if should preload the next section.
        if indexPath.section + 1 > maxDateFromNow - minDateFromNow {
            maxDateFromNow += 1
            updateSnapshot()
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        guard let minVisibleIndexPath = eventCollectionView.indexPathsForVisibleItems.min() else {
            print("Fail to get min visible index path for event collection view.")
            return
        }
        
        if minVisibleIndexPath.section == 0 {
            minDateFromNow -= 1
            updateSnapshot()
        }
        
    }
//
//    func configureGestureRecognizers() {
//
//        let upGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
//        upGestureRecognizer.direction = .up
//        eventCollectionView.addGestureRecognizer(upGestureRecognizer)
//
//        let downGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
//        downGestureRecognizer.direction = .down
//        eventCollectionView.addGestureRecognizer(downGestureRecognizer)
//
//    }
//
//
//    @objc func swipeHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {
//
//        print("recieved swipe.")
//
//        if gestureRecognizer.state == .began {
//            if gestureRecognizer.direction == .up {
//                print("recieved swipe up.")
//                // Check if should preload the next section.
//                guard let maxIndexPath = eventCollectionView.indexPathsForVisibleItems.max() else {
//                    print("Fail to retrive max visible index path.")
//                    return
//                }
//                if maxIndexPath.section + 1 > maxDateFromNow {
//                    maxDateFromNow += 1
//                    updateSnapshot()
//                }
//            } else if gestureRecognizer.direction == .down {
//                print("recieved swipe down.")
//                // Check if should preload the next section.
//                guard let minIndexPath = eventCollectionView.indexPathsForVisibleItems.min() else {
//                    print("Fail to retrive min visible index path.")
//                    return
//                }
//                if minIndexPath.section - 1 < minDateFromNow {
//                    minDateFromNow -= 1
//                    updateSnapshot()
//                }
//            }
//        }
//
//    }
    
}
