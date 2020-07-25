//
//  MonthViewController.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/25.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit

class MonthViewController: UIViewController {
    
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
    /// Collection view scroll view current y
    private var currentY: Double = 480

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coreDataController = CoreDataController(appDelegate: appDelegate, context: context)
        configureCollectionDataSource()
        configureCollectionLayout()
        //dayCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load course data after the view appears.
        updateSnapshot()
    }
    
}

// Collection View Layout

extension MonthViewController {
    
    /// Configure the layout of the movie preview collection view
    private func configureCollectionLayout() {
        dayCollectionView.collectionViewLayout = createLayout()
    }
    
    /// Create a new collection view compositional layout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
//            let headerAnchor = NSCollectionLayoutAnchor(edges: [.top], fractionalOffset: CGPoint(x: 0, y: -1))
//            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                    heightDimension: .estimated(10))
//            let header = NSCollectionLayoutSupplementaryItem(
//                layoutSize: headerSize,
//                elementKind: "header",
//                containerAnchor: headerAnchor)
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [header])
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
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.secondarySystemFill.cgColor
            cell.contentScrollView.backgroundColor = .systemBackground
            let frameWidth = Double(cell.bounds.width)
            cell.contentScrollView.contentSize = CGSize(width: frameWidth, height: 480)
            
            // Event subcells
            var eventViewY = 0.0
            
            for event in dayevents.events {
                
                let eventFrame = CGRect(x: 2, y: eventViewY + 2, width: frameWidth - 4, height: 18)
                let eventView = UIView(frame: eventFrame)
                eventView.backgroundColor = (event.color as? UIColor) ?? .secondarySystemBackground
                eventView.layer.cornerRadius = 8
                
                let nameFrame = CGRect(x: 0, y: 0, width: frameWidth - 4, height: 18)
                let nameLabel = UILabel(frame: nameFrame)
                nameLabel.text = event.name
                nameLabel.font = .preferredFont(forTextStyle: .body)
                nameLabel.textAlignment = .left
                eventView.addSubview(nameLabel)
                
                cell.contentScrollView.addSubview(eventView)
                eventViewY += 20.0
                
            }
            
            cell.contentScrollView.layoutSubviews()
            
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
        let daysFromNow = indexPath.row
        
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
    
    /// Updates the snapshot using NSFetchRequest
    private func updateSnapshot() {
        
        // Update snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section,DayEvents>()
        snapshot.appendSections([.main])
        let calendar = Calendar.current
        let now = Date()
        let monthStart = calendar.date(from: calendar.dateComponents([.year,.month], from: now))!
        let dayStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: monthStart))!
        
        for daysFromStart in 0 ..< 42 {
            guard let then = calendar.date(byAdding: DateComponents(day: daysFromStart), to: dayStart) else {
                print("Fail to compute the date \(daysFromStart) days from month start.")
                return
            }
            if let events = coreDataController.fetchEventRequest(on: then) {
                snapshot.appendItems([DayEvents(day: then, events: events)], toSection: .main)
            }
        }
        dayCollectionViewDiffableDataSource.apply(snapshot)
        
    }
    
}
