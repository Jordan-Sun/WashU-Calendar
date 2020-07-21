//
//  TodayViewController.swift
//  WashU Calendar
//
//  Created by Coco Zhu on 7/20/20.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit
import CoreData

class TodayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    

    let currentDate = Date()
    
    
    @IBOutlet weak var theCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theCollectionView.dataSource = self
        theCollectionView.delegate = self
        theCollectionView.register(OneDayCollectionViewCell.self, forCellWithReuseIdentifier: "oneDayCell")
        setUpCollectionView()
        
        // Do any additional setup after loading the view.
    }
    
    /// for now we just display one-day view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func setUpCollectionView() {
        theCollectionView.collectionViewLayout = configureLayout()
    }
    
    
    /// functionality: set up a one-day view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = theCollectionView.dequeueReusableCell(withReuseIdentifier: "oneDayCell", for: indexPath) as! OneDayCollectionViewCell
        
        /// set up scroll view in collection view cell
        let theScrollView = UIScrollView(frame: cell.frame)
        cell.addSubview(theScrollView)
        theScrollView.delegate = self
        theScrollView.backgroundColor = .white
        
        let bigFrame = CGRect(x: 0, y: 0, width: 375, height: 1440)
        let myImageView = UIImageView(frame: bigFrame)
        theScrollView.addSubview(myImageView)
        theScrollView.contentSize = CGSize(width: 375, height: 1440)
        
        /// some design of layout
        for i in 0 ..< 24 {
            let oneHourFrame = CGRect(x: 0, y: 60 * i, width: 375, height: 60)
            let oneHourImageView = UIImageView(frame: oneHourFrame)
            
            let textFrame = CGRect(x: 0, y: 60 * i, width: 53, height: 20)
            let textView = UILabel(frame: textFrame)
            textView.text = "\(i):00"
            textView.textColor = .black
            textView.font = .systemFont(ofSize: 13, weight: .light)
            textView.textAlignment = .right
            
            oneHourImageView.backgroundColor = .white
            if i % 2 == 0{
                oneHourImageView.layer.borderWidth = 1
                oneHourImageView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
            myImageView.addSubview(oneHourImageView)
            myImageView.addSubview(textView)
        }
        
        /// add a border between left content and right content
        let borderFrame = CGRect(x: 0, y: 0, width: 56, height: 1440)
        let borderImageView = UIImageView(frame: borderFrame)
        borderImageView.layer.borderWidth = 2
        borderImageView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        myImageView.addSubview(borderImageView)
        
        myImageView.layer.borderWidth = 2
        myImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        /// write a loop for [Event] in the futrue
        /// test: add cse 438s to daily view, class starts at 13:00 and lasts for 80 minutes
        let time1 = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!
        addEventToTimeTable(on: myImageView, courseName: "CSE 131", startTime: time1, length: 80 * 60, cellColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
        /// test: add cse 438s to daily view, class starts at 14:30 and lasts for 50 minutes
        let time2 = Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: Date())!
        addEventToTimeTable(on: myImageView, courseName: "CSE 247", startTime: time2, length: 50 * 60, cellColor: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
        
        /// add a line to represent current time
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        let minute = calendar.component(.minute, from: Date())
        let yLabel = Int(60 * hour + minute) - 10
        
        let nowFrame = CGRect(x: 56, y: yLabel, width: 319, height: 20)
        let nowTextView = UILabel(frame: nowFrame)
        nowTextView.text = "---------------------- Now -----------------------"
        nowTextView.font = .systemFont(ofSize: 13, weight: .light)
        nowTextView.textAlignment = .center
        myImageView.addSubview(nowTextView)
        
        /// first view of this screen will display 8:00 - 18:00
        theScrollView.contentOffset = .init(x: 0, y: 440)
        
        return cell
    }
        
        
    /// functionality: set up the layout of collection view
    func configureLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)

    }
    
    
    /// can be revised to func add( _ event: Event, cellColor: UIColor) { }
    func addEventToTimeTable(on imageView: UIImageView, courseName: String, startTime: Date, length: TimeInterval, cellColor: UIColor) {
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: startTime)
        let minute = calendar.component(.minute, from: startTime)
        
        let yLabel = Int(60 * hour + minute)
        let height = Int(length / 60)
        
        let eventFrame = CGRect(x: 58, y: yLabel, width: 312, height: height)
        let eventImageView = UIImageView(frame: eventFrame)
        eventImageView.layer.cornerRadius = 10
        eventImageView.layer.masksToBounds = true
        eventImageView.backgroundColor = cellColor
        imageView.addSubview(eventImageView)
        
        let labelFrame = CGRect(x: 10, y: 0, width: 312, height: 20)
        let courseLabel = UILabel(frame: labelFrame)
        /// customize course label
        courseLabel.text = courseName
        courseLabel.font = .systemFont(ofSize: 13, weight: .bold)
        courseLabel.textColor = .white
        courseLabel.textAlignment = .left
        eventImageView.addSubview(courseLabel)
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
