//
//  EventCollectionViewCell.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/18.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "eventCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
}
