//
//  TodayViewController.swift
//  WashU Calendar
//
//  Created by Coco Zhu on 7/20/20.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit
import CoreData

class TodayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    let currentDate = Date()
    
    
    @IBOutlet weak var theCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theCollectionView.dataSource = self
        theCollectionView.delegate = self
        theCollectionView.register(OneDayCollectionViewCell.self, forCellWithReuseIdentifier: "oneDayCell")
        setUpCollectionView()
        
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: currentDate)
//        let minutes = calendar.component(.minute, from: currentDate)

        // Do any additional setup after loading the view.
    }
    
    /// for now we just display one-day view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func setUpCollectionView() {
        theCollectionView.collectionViewLayout = configureLayout()
    }
    
    
    /// following code is learned from video: https://www.hackingwithswift.com/read/10/2/designing-uicollectionview-cells
    /// functionality: set up a one-day view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = theCollectionView.dequeueReusableCell(withReuseIdentifier: "oneDayCell", for: indexPath) as! OneDayCollectionViewCell
//        cell.theScrollView.backgroundColor = .systemPink
        cell.date = currentDate
            
        return cell
    }
        
        
    /// following code is learned from video: https://www.youtube.com/watch?v=ZXupp2kOcSI
    /// functionality: set up the layout of collection view
        func configureLayout() -> UICollectionViewCompositionalLayout {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            return UICollectionViewCompositionalLayout(section: section)

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
