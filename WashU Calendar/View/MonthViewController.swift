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
    @IBOutlet weak var monthCollectionView: UICollectionView!
    /// Collection view section
    enum Section {
        case main
    }
    /// Collection view data source
    private var monthCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Section,DayEvents>!
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
        monthCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Section,DayEvents>(collectionView: self.monthCollectionView) { (collectionView, indexPath, dayevents) -> UICollectionViewCell? in
            
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
            var eventViewY = 20.0
            
            let headerFrame = CGRect(x: 2, y: 2, width: frameWidth - 4, height: 18)
            let headerView = UILabel(frame: headerFrame)
            let calendar = Calendar.current
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            let dayOfMonth = calendar.dateComponents([.day], from: dayevents.day)
            if dayOfMonth == DateComponents(day: 1) {
                dateFormatter.setLocalizedDateFormatFromTemplate("MMMd")
            } else {
                dateFormatter.setLocalizedDateFormatFromTemplate("d")
            }
            headerView.text = dateFormatter.string(from: dayevents.day)
            headerView.textAlignment = .center
            headerView.font = .preferredFont(forTextStyle: .headline)
            cell.contentScrollView.addSubview(headerView)
            
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
        
    }
    
    /// Updates the snapshot using NSFetchRequest
    private func updateSnapshot() {
        
        // Update snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section,DayEvents>()
        snapshot.appendSections([.main])
        let calendar = Calendar.current
        let now = appDelegate.currentDate
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
        monthCollectionViewDiffableDataSource.apply(snapshot)
        
    }
    
}
