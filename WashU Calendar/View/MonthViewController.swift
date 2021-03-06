//
//  MonthViewController.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/25.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit
import CoreData

class MonthViewController: UIViewController {
    
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
    @IBOutlet weak var monthCollectionView: UICollectionView!
    /// Collection view section
    enum Section {
        case main
    }
    /// Collection view data source
    private var monthCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Section,DayEvents>!
    /// The min section
    private var minMonthFromNow = -3
    /// The max section
    private var maxMonthFromNow = 3
    /// A boolean indicating whether the collection view should preload cell
    private var shouldPreloadCell = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        coreDataController = CoreDataController(appDelegate: appDelegate, context: context)
        coreDataController.delegate = self
        
        configureCollectionDataSource()
        configureCollectionLayout()
        monthCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load course data after the view appears.
        updateSnapshot()
        monthCollectionView.scrollToItem(at: IndexPath(row: 42 * -minMonthFromNow, section: 0), at: .left, animated: false)
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

extension MonthViewController {
    
    /// Configure the layout of the movie preview collection view
    private func configureCollectionLayout() {
        monthCollectionView.collectionViewLayout = createLayout()
    }
    
    /// Create a new collection view compositional layout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            let weekGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let weekGroup = NSCollectionLayoutGroup.horizontal(layoutSize: weekGroupSize, subitem: item, count: 7)
            
            let monthGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let monthGroup = NSCollectionLayoutGroup.vertical(layoutSize: monthGroupSize, subitem: weekGroup, count: 6)
            
            let section = NSCollectionLayoutSection(group: monthGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
            
        }
        
        return layout
        
    }
    
}

// Collection View Data Source

extension MonthViewController {
    
    /// Configure the datasource of the movie preview collection view
    private func configureCollectionDataSource() {
        
        // Diffable data source cell provider
        monthCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Section,DayEvents>(collectionView: self.monthCollectionView) { (collectionView, indexPath, dayEvents) -> UICollectionViewCell? in
            
            // Dequeue reuseable cell.
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.reuseIdentifier, for: indexPath) as? DayCollectionViewCell else {
                fatalError("Expected reused cell to be of type DayCollectionViewCell.")
            }
            
            // Clean up cell
            for subview in cell.contentScrollView.subviews {
                subview.removeFromSuperview()
            }
            
            // Update cell
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.secondarySystemFill.cgColor
            cell.contentScrollView.backgroundColor = .systemBackground
            let frameWidth = Double(cell.bounds.width)
            cell.contentScrollView.contentSize = CGSize(width: frameWidth, height: 480)
            
            // Event subcells
            let date = dayEvents.day
            let headerFrame = CGRect(x: 2, y: 2, width: frameWidth - 4, height: 18)
            let headerView = UILabel(frame: headerFrame)
            let calendar = Calendar.current
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            let dayOfMonth = calendar.dateComponents([.day], from: date)
            if dayOfMonth == DateComponents(day: 1) {
                dateFormatter.setLocalizedDateFormatFromTemplate("MMMd")
            } else {
                dateFormatter.setLocalizedDateFormatFromTemplate("d")
            }
            headerView.text = dateFormatter.string(from: date)
            headerView.textAlignment = .center
            headerView.font = .preferredFont(forTextStyle: .headline)
            cell.contentScrollView.addSubview(headerView)
            
            let events = dayEvents.events
            var eventViewY = 20.0
            
            for event in events {
                
                let eventFrame = CGRect(x: 2, y: eventViewY + 2, width: frameWidth - 4, height: 18)
                let eventView = EventView(frame: eventFrame)
                eventView.backgroundColor = (event.color as? UIColor) ?? .secondarySystemBackground
                eventView.layer.cornerRadius = 8
                eventView.event = event
                
                let nameFrame = CGRect(x: 0, y: 0, width: frameWidth - 4, height: 18)
                let nameLabel = UILabel(frame: nameFrame)
                nameLabel.text = event.name
                nameLabel.font = .preferredFont(forTextStyle: .body)
                nameLabel.textAlignment = .left
                eventView.addSubview(nameLabel)
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didSelectEventViewAt(_:)))
                tapGestureRecognizer.numberOfTapsRequired = 1
                tapGestureRecognizer.numberOfTouchesRequired = 1
                eventView.addGestureRecognizer(tapGestureRecognizer)
                eventView.isUserInteractionEnabled = true
                
                cell.contentScrollView.addSubview(eventView)
                eventViewY += 20.0
                
            }
            
            let month = calendar.dateComponents([.month], from: date).month!
            let sectionMonth = calendar.dateComponents([.second], from: date).second!
            if month == sectionMonth {
                cell.contentScrollView.backgroundColor = .systemBackground
            } else {
                cell.contentScrollView.backgroundColor = .secondarySystemBackground
            }
            
            cell.contentScrollView.layoutSubviews()
            
            return cell
            
        }
        
    }
    
    /// Updates the snapshot using NSFetchRequest
    private func updateSnapshot() {
        
        shouldPreloadCell = false
        // Update snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section,DayEvents>()
        snapshot.appendSections([.main])
        let calendar = Calendar.current
        let now = appDelegate.currentDate
        let nowMonthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        
        for monthsFromStart in minMonthFromNow ..< maxMonthFromNow {
            
            let monthStart = calendar.date(byAdding: DateComponents(month: monthsFromStart), to: nowMonthStart)!
            let month = calendar.dateComponents([.month], from: monthStart).month!
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: monthStart))!
            let start = calendar.date(byAdding: DateComponents(second: month), to: weekStart)!
            
            var daysEvents = [DayEvents]()
            for daysFromStart in 0 ..< 42 {
                guard let then = calendar.date(byAdding: DateComponents(day: daysFromStart), to: start) else {
                    print("Fail to compute the date \(daysFromStart) days from month start.")
                    return
                }
                let events = coreDataController.fetchEventRequest(on: then) ?? [Event]()
                daysEvents.append(DayEvents(day: then, events: events))
            }
            snapshot.appendItems(daysEvents, toSection: .main)
            
        }
        
        monthCollectionViewDiffableDataSource.apply(snapshot)
        shouldPreloadCell = true
        
    }
    
}

// Collection View Delegate

extension MonthViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if shouldPreloadCell {
            if indexPath.row == 0 {
                minMonthFromNow -= 1
                updateSnapshot()
                monthCollectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .left, animated: false)
            } else if indexPath.row == (maxMonthFromNow - minMonthFromNow) * 42 - 10 {
                maxMonthFromNow += 1
                updateSnapshot()
            }
        }
        
    }
    
    @objc func didSelectEventViewAt(_ sender: UIGestureRecognizer) {
        
        guard let senderView = sender.view as? EventView else {
            print("Fail to get the event view attached to the UIGestureRecognizer")
            return
        }
        
        let detailView = EventDetailViewController()
        detailView.event = senderView.event
        detailView.coreDataController = coreDataController
        navigationController?.pushViewController(detailView, animated: true)
        
    }
    
}

extension MonthViewController: CoreDataControllerDelegate {
    
    func controllerDidChangeContent() {
        self.updateSnapshot()
    }
    
}
