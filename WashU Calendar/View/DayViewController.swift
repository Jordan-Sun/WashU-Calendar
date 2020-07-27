//
//  DayViewController.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/21.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit

struct DayEvents: Hashable {
    var day: Date
    var events: [Event]
}

class DayViewController: UIViewController {
    
    // Core Data Component
    /// App delegate
    private var appDelegate = UIApplication.shared.delegate as!  AppDelegate
    /// Core data context
    private var context = (UIApplication.shared.delegate as!  AppDelegate).persistentContainer.viewContext
    /// Core data controller
    private var coreDataController: CoreDataController!

    // Collection View Component
    /// Collection view
    @IBOutlet weak var dayCollectionView: UICollectionView!
    /// Collection view section
    enum Section {
        case main
    }
    /// Collection view data source
    private var dayCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Section,DayEvents>!
    /// Collection view per hour height
    private var hourHeight: Double = 60
    /// Collection view scroll view current y
    private var currentY: Double = 480
    /// The min section
    private var minDateFromNow = -3
    /// The max section
    private var maxDateFromNow = 3
    /// A boolean indicating whether the collection view should preload cell
    private var shouldPreloadCell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coreDataController = CoreDataController(appDelegate: appDelegate, context: context)
        configureCollectionDataSource()
        configureCollectionLayout()
        dayCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load course data after the view appears.
        updateSnapshot()
        dayCollectionView.scrollToItem(at: IndexPath(row: -minDateFromNow, section: 0), at: .left, animated: false)
    }
    
    @IBAction func pushAddView(_ sender: Any) {
        let newViewController = AddEventViewController()
        present(newViewController, animated: true, completion: nil)

    }

}

// Collection View Layout

extension DayViewController {
    
    /// Configure the layout of the movie preview collection view
    private func configureCollectionLayout() {
        dayCollectionView.collectionViewLayout = createLayout()
    }
    
    /// Create a new collection view compositional layout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let headerAnchor = NSCollectionLayoutAnchor(edges: [.top], fractionalOffset: CGPoint(x: 0, y: -1))
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(44))
            let header = NSCollectionLayoutSupplementaryItem(
                layoutSize: headerSize,
                elementKind: "header",
                containerAnchor: headerAnchor)
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [header])
            item.contentInsets = NSDirectionalEdgeInsets(top: 44, leading: 8, bottom: 4, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
            
        }
        
        return layout
        
    }
    
}


// Collection View Data Source

extension DayViewController {
    
    /// Configure the datasource of the movie preview collection view
    private func configureCollectionDataSource() {
        
        // Diffable data source cell provider
        dayCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Section,DayEvents>(collectionView: self.dayCollectionView) { (collectionView, indexPath, dayevents) -> UICollectionViewCell? in
            
            // Dequeue reuseable cell.
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.reuseIdentifier, for: indexPath) as? DayCollectionViewCell else {
                fatalError("Expected reused cell to be of type DayCollectionViewCell.")
            }
            
            // Clean up cell
            for subview in cell.contentScrollView.subviews {
                subview.removeFromSuperview()
            }
            
            // Update cell
            cell.contentScrollView.backgroundColor = .systemBackground
            let frameWidth = Double(cell.bounds.width)
            cell.contentScrollView.contentSize = CGSize(width: frameWidth, height: self.hourHeight * 24 + 40)
            
            // Time sheet
            for hour in 0 ..< 24 {
                let hourFrame = CGRect(x: 50, y: self.hourHeight * Double(hour), width: frameWidth - 40, height: self.hourHeight)
                let hourView = UIView(frame: hourFrame)
                hourView.backgroundColor = .systemBackground
                hourView.layer.borderWidth = 1
                hourView.layer.borderColor = UIColor.secondarySystemFill.cgColor
                
                cell.contentScrollView.addSubview(hourView)
            }
            for hour in 0 ... 24 {
                let textFrame = CGRect(x: -10, y: self.hourHeight * (Double(hour) - 0.5), width: 60, height: self.hourHeight)
                let textView = UILabel(frame: textFrame)
                textView.text = "\(hour):00"
                textView.textColor = .label
                textView.font = .preferredFont(forTextStyle: .body)
                textView.textAlignment = .right
                
                cell.contentScrollView.addSubview(textView)
            }
            
            // Timeline
            let calendar = Calendar.current
            let dayStart = calendar.startOfDay(for: dayevents.day)
            let now = Date()
            if dayStart == calendar.startOfDay(for: now) {
                let timelineViewY = DateInterval(start: dayStart, end: now).duration * self.hourHeight / 3600
                let timelineFrame = CGRect(x: 40, y: timelineViewY - 2, width: frameWidth, height: 4)
                let timelineView = UIView(frame: timelineFrame)
                timelineView.backgroundColor = .systemTeal
            }
            
            // Event subcells
            for event in dayevents.events {
                
                let eventViewY = DateInterval(start: dayStart, end: event.start!).duration * self.hourHeight / 3600
                let eventViewHeight = max(DateInterval(start: event.start!, end: event.end!).duration * self.hourHeight / 3600, self.hourHeight/2)
                let eventFrame = CGRect(x: 54, y: eventViewY + 4, width: frameWidth - 58, height: eventViewHeight - 8)
                let eventView = UIView(frame: eventFrame)
                eventView.backgroundColor = (event.color as? UIColor) ?? .secondarySystemBackground
                eventView.layer.cornerRadius = 8
                
                let nameFrame = CGRect(x: 4, y: 4, width: frameWidth - 8, height: 30)
                let nameLabel = UILabel(frame: nameFrame)
                nameLabel.text = event.name
                nameLabel.font = .preferredFont(forTextStyle: .headline)
                nameLabel.textAlignment = .left
                eventView.addSubview(nameLabel)
                
                let timeFrame = CGRect(x: frameWidth/2 - 29, y: 34, width: frameWidth/2 - 33, height: 30)
                let timeLabel = UILabel(frame: timeFrame)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                timeLabel.text = "\(dateFormatter.string(from: event.start!))-\(dateFormatter.string(from: event.end!))"
                timeLabel.font = .preferredFont(forTextStyle: .callout)
                timeLabel.textAlignment = .right
                eventView.addSubview(timeLabel)
                
                let locationFrame = CGRect(x: 4, y: 34, width: frameWidth/2 - 33, height: 30)
                let locationLabel = UILabel(frame: locationFrame)
                locationLabel.text = event.location ?? "TBA"
                locationLabel.font = .preferredFont(forTextStyle: .body)
                locationLabel.textAlignment = .left
                eventView.addSubview(locationLabel)
                
                cell.contentScrollView.addSubview(eventView)
            }
            
            cell.contentScrollView.layoutSubviews()
            cell.contentScrollView.contentOffset = .init(x: 0, y: self.currentY)
            
            return cell
            
        }
        
        // Register header as a supplementary view to the collection view
        dayCollectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: HeaderCollectionReusableView.reuseIdentifier)
        
        // Diffable data source supplementary view provider
        dayCollectionViewDiffableDataSource.supplementaryViewProvider = {
            (collectionView, kind, indexPath) -> UICollectionReusableView? in
            
            // Check is proving a rating badge supplementary view
            switch kind {
            case "header":
                return self.createHeader(collectionView: collectionView, indexPath: indexPath)
            default:
                return nil
            }
            
        }
        
    }
    
    private func createHeader(collectionView: UICollectionView, indexPath: IndexPath) -> HeaderCollectionReusableView? {
        
        // Dequeue reuseable supplementary view
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: HeaderCollectionReusableView.reuseIdentifier, for: indexPath) as? HeaderCollectionReusableView else {
            fatalError("Expected reused badge to be of type HeaderCollectionReusableView.")
        }
        
        // Get genre section at the target index path
        let calendar = Calendar.current
        guard let then = dayCollectionViewDiffableDataSource.itemIdentifier(for: indexPath)?.day else {
            print("Fail to retrive day from \(indexPath).")
            return nil
        }
        let daysFromNow = calendar.dateComponents([.day], from: calendar.startOfDay(for: appDelegate.currentDate), to: calendar.startOfDay(for: then) )
        // Configure header
        switch daysFromNow {
        case DateComponents(day: -1):
            header.label.text = "Yesterday"
        case DateComponents(day: 0):
            header.label.text = "Today"
        case DateComponents(day: 1):
            header.label.text = "Tomorrow"
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd, EEEE")
            header.label.text = dateFormatter.string(from: then)
        }
        
        return header
        
    }
    
    /// Updates the snapshot using NSFetchRequest
    private func updateSnapshot() {
        
        shouldPreloadCell = false
        // Update snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section,DayEvents>()
        snapshot.appendSections([.main])
        let calendar = Calendar.current
        let now = appDelegate.currentDate
        for daysFromNow in minDateFromNow ... maxDateFromNow {
            guard let then = calendar.date(byAdding: DateComponents(day: daysFromNow), to: now) else {
                print("Fail to compute the date \(daysFromNow) days from now.")
                return
            }
            if let events = coreDataController.fetchEventRequest(on: then) {
                snapshot.appendItems([DayEvents(day: then, events: events)], toSection: .main)
            }
        }
        dayCollectionViewDiffableDataSource.apply(snapshot)
        shouldPreloadCell = true
        
    }
    
}

// Collection View Delegate

extension DayViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if shouldPreloadCell {
            if indexPath.row == 0 {
                minDateFromNow -= 1
                updateSnapshot()
                dayCollectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .left, animated: false)
            } else if indexPath.row == maxDateFromNow - minDateFromNow {
                maxDateFromNow += 1
                updateSnapshot()
            }
        }
        
    }
    
}
